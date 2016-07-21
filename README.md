# YoudaoDict

This is an simple command line application using Youdao Dict api to translate words from/to Chinese.

## Installation

1. git clone this project
2. run `mix escript.build` to generate binary file
3. copy generated binary to you `$PATH`

## Usage

```sh
$ dict hello

  test [test]
=========== 辞典翻译:  ===========
  n. 试验；检验
  vt. 试验；测试
  vi. 试验；测试
  n. (Test)人名；(英)特斯特
------------ 网络释义 ------------
------------ Test ------------
  测试
  测验
  检验
--------- Test Drive ---------
  Test Drive
  Test Drive
  无限狂飙
-------- Test Engineer -------
  测试员
  测试工程师
  软件测试工程师
```

```sh
$ dict 蛋糕

  蛋糕 [dàn gāo]
=========== 辞典翻译:  ===========
  [食品] cake
------------ 网络释义 ------------
------------- 蛋糕 -------------
  Cake
  cake
  Gâteau
------------ 结婚蛋糕 ------------
  wedding cake
  Wedding cake
  웨딩 케이크
------------ 水果蛋糕 ------------
  Fruit cake
  ショートケーキ
  Shortcake
```
