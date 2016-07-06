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

  test "it return centered string by center function" do
    assert YoudaoDict.center("hello", 5) == "hello"
    assert YoudaoDict.center("hello", 10) == "== hello ="
    assert YoudaoDict.center("hello", 6) == " hello"
    assert YoudaoDict.center("hello", 7) == " hello "
    assert YoudaoDict.center("hello", 9) == "= hello ="
    assert YoudaoDict.center("hello", 9, ?*) == "* hello *"
  end
end
