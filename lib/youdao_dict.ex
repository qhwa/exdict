defmodule YoudaoDict.CLI do

  @moduledoc """
    Handle the command line parsing
  """

  def main argv do
    argv |> parse_args |> process
  end

  def parse_args(args) do
    case OptionParser.parse(args) do
      {options, [word], _}  ->
        {:ok, word, options}
      _ ->
        {:err}
    end
  end

  def process({:ok, word, _options}) do
    YoudaoDict.translate(word) |> YoudaoDict.print_out
  end

  def process({:err}) do
    IO.puts "usage: dict <word>"
  end

end

defmodule YoudaoDict do

  def translate(word) do
    word
      |> fetch_translation
      |> parse
      |> Map.merge(%{ word: word })
  end

  defp fetch_translation(word) do
    :inets.start()

    "http://dict.youdao.com/fsearch?q=" <> word
      |> to_char_list
      |> :httpc.request
  end

  defp parse({:ok, {_, _, body}}) do
    { doc, _ } = :xmerl_scan.string(body)
    %{
      :phonetic               => parse_phonetic_symbol(doc),
      :official_translations  => parse_translation(doc),
      :web_translations       => parse_web_translations(doc)
    }
  end

  defp parse_phonetic_symbol(document) do
    document
      |> map_nodes('//phonetic-symbol[1]/text()[1]', &node_text/1)
  end

  defp map_nodes(node, path, mapper \\ &node_text/1) do
    :xmerl_xpath.string(path, node) |> Enum.map(mapper)
  end

  defp node_text(node) do
    case node do
      {:xmlText, _, _, _, symbol, _} ->
        to_string(symbol)
      _ ->
        nil
    end
  end

  defp parse_translation(document) do
    document
      |> map_nodes('//translation/content/text()')
  end

  defp parse_web_translations(document) do
    document
      |> map_nodes('//yodao-web-dict/web-translation', &parse_web_translation/1)
  end

  defp parse_web_translation(node) do
    key = node |> first_node_text("key")
    trans = node |> map_nodes('//trans/value/text()')
    { key, trans }
  end

  defp first_node_text(node, path) do
    nodes = (path <> "/text()") |> to_char_list |> :xmerl_xpath.string(node)
    [first|_] = nodes
    node_text(first)
  end

  def print_out(%{
    phonetic: phonetic,
    official_translations: official_translations,
    web_translations: web_translations,
    word: word
  }) do

    IO.write indent() <> word
    case length(phonetic) > 0 do
      true -> IO.write cyan(" [" <> Enum.join(phonetic, ", ") <> "]\n")
      false -> IO.write "\n"
    end

    title "辞典翻译: ", ?=
    Enum.each(official_translations, fn(trans) -> IO.puts indent() <> green(trans) end)

    title "网络释义"
    Enum.each(web_translations, &print_web_translation/1)
  end

  defp title(word, padder \\ ?-, len \\ 30) do
    word
      |> center(len, padder)
      |> IO.puts
  end

  defp indent(width \\ 2) do
    String.duplicate(" ", width)
  end

  defp cyan(text) do
    "\e[36m" <> text <> "\e[0m"
  end

  defp green(text) do
    "\e[32m" <> text <> "\e[0m"
  end

  defp print_web_translation({ key, translations }) do
    title key
    Enum.each(translations, fn(trans) -> IO.puts(indent() <> trans) end)
  end

  def center(word, length, padder \\ ?=) do
    word_len = String.length(word)

    case word_len do

      0 ->
        String.duplicate(padder, length)

      _ when word_len >= length ->
        word

      _ when word_len == length - 1 ->
        " " <> word

      _ when word_len == length - 2 ->
        " " <> word <> " "

      len ->
        padding = div(length - len, 2) - 1

        Enum.join([
          String.duplicate(<<padder>>, length - padding - len - 2),
          word,
          String.duplicate(<<padder>>, padding)
        ], " ")
    end
  end

end
