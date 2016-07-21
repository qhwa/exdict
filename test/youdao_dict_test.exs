defmodule YoudaoDictTest do
  use ExUnit.Case
  doctest YoudaoDict

  test "it should translate word 'test'" do
    translation = YoudaoDict.translate("what")

    assert Map.take(translation, [:phonetic, :official_translations, :word]) == %{
      phonetic: ["hwɔt, hwʌt, 弱hwət"],
      official_translations: [
        "pron. 什么；多么；多少",
        "adv. 到什么程度，在哪一方面",
        "adj. 什么；多么；何等",
        "int. 什么；多么"
      ],
      word: "what"
    }

    assert translation.web_translations
  end

  test "it should translate chinese word" do
    translation = YoudaoDict.translate("世界")
    assert translation == %{
      official_translations: ["world", "earth", "welt"],
      phonetic: ["shì jiè"],
      web_translations: [
        {"世界", ["World", "world", "世界"]},
        {"世界观", ["world view", "Weltanschauung", "世界観"]},
        {"粘粘世界", ["World of Goo", "グーの惑星", "월드 오브 구"]}
      ],
      word: "世界"
    }
  end

  test "it return centered string by center function" do
    assert YoudaoDict.center("hello", 5) == "hello"
    assert YoudaoDict.center("hello", 10) == "== hello ="
    assert YoudaoDict.center("hello", 6) == " hello"
    assert YoudaoDict.center("hello", 7) == " hello "
    assert YoudaoDict.center("hello", 9) == "= hello ="
    assert YoudaoDict.center("hello", 9, ?*) == "* hello *"
  end
end
