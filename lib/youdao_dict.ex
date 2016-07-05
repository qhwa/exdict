defmodule YoudaoDict do

  def main(word) do
    translate(word) |> print_out
  end

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
      |> all_nodes('//phonetic-symbol[1]/text()[1]')
      |> Enum.map(&node_text/1)
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
      |> all_nodes('//translation/content/text()')
      |> Enum.map(&node_text/1)
  end

  defp parse_web_translations(document) do
    document
      |> all_nodes('//yodao-web-dict/web-translation')
      |> Enum.map(&parse_web_translation/1)
  end

  defp parse_web_translation(node) do
    key = node |> first_node_text("key")
    trans = node |> all_nodes('//trans/value/text()') |> Enum.map(&node_text/1)
    { key, trans }
  end

  defp first_node_text(node, path) do
    nodes = (path <> "/text()") |> to_char_list |> :xmerl_xpath.string(node)
    [first|_] = nodes
    node_text(first)
  end

  defp all_nodes(node, path) do
    :xmerl_xpath.string(path, node)
  end

  defp print_out(%{
    phonetic: phonetic,
    official_translations: official_translations,
    web_translations: web_translations,
    word: word
  }) do

    IO.write indent() <> word
    if length(phonetic) > 0 do
      IO.write cyan(" [" <> Enum.join(phonetic, ", ") <> "]\n")
    end

    IO.puts "=== " <> "辞典翻译: " <> word <> " ==="

    Enum.each(official_translations, fn(trans) -> IO.puts indent() <> green(trans) end)

    IO.puts "=== " <> "网络释义" <> " ==="
    Enum.each(web_translations, &print_web_translation/1)
  end

  defp indent(width \\ 2) do
    "  "
  end

  defp cyan(text) do
    "\e[36m" <> text <> "\e[0m"
  end

  defp green(text) do
    "\e[32m" <> text <> "\e[0m"
  end

  defp print_web_translation({ key, translations }) do
    IO.puts "--- " <> key <> " ---"
    Enum.each(translations, fn(trans) -> IO.puts(indent() <> trans) end)
  end

end
