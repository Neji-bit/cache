# cache

## 動作環境

MacBook, zsh 環境を前提とします。

## これはなに？

コンソール作業における「標準出力されたテキスト情報」を、キャッシュファイル（~/.cache）に保存するシェルスクリプトです。
キャッシュファイルに保存されたものについて、以下のことができます。

* １：再表示
* ２：行を指定した再表示

## 使い方_導入

cashe.sh 単品で機能します。このシェルスクリプトを、どこかパスの通ったところに配置してください。
aliasを設定することをおすすめします。

私の例：
```
alias _c="~/script/cache.sh"
alias _n="~/script/cache.sh -n"
```

## 使い方_ユースケース

「ファイルを10件持つディレクトリで一覧（ls）をキャッシュし、その後5番目と8,10番目のファイル名だけを出力する」シナリオを実践します。

```
# 普通のls
$ ls
> a.log b.log c.log d.log e.log
> f.log g.log h.log i.log j.log

# キャッシュに入れる（＝入れると同時に標準出力もされる）

$ ls | cache.sh
> a.log
> b.log
> c.log
> d.log
> e.log
> f.log
> g.log
> h.log
> i.log
> j.log

# 行数つきでキャッシュを再表示する

$ cache.sh -n
>  1 a.log
>  2 b.log
>  3 c.log
>  4 d.log
>  5 e.log
>  6 f.log
>  7 g.log
>  8 h.log
>  9 i.log
> 10 j.log

# 5, 8-10行目だけを再表示する（わかりやすいように、キャッシュ上の行数も表示）
$ cache.sh -n 5 8,10
>  5 e.log
>  8 h.log
>  9 i.log
> 10 j.lon

```
