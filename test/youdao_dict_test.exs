defmodule YoudaoDictTest do
  use ExUnit.Case
  doctest YoudaoDict

  test "it should translate word 'test'" do
    translation = YoudaoDict.translate("task")
    assert translation == %{
      phonetic: ["tɑ:sk, tæsk"],
      official_translations: ["n. 工作，作业；任务", "vt. 分派任务"],
      web_translations: [
        {"Task", ["任务", "工作", "作业"]},
        {"Task List", ["任务列表", "工作清单", "任务清单"]},
        {"Task Assignments", ["指派工作", "指派任务"]}
      ],
      word: "task"
    }
  end
end
