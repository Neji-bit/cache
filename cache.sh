#!/bin/zsh

# タイトル：キャッシュ

# 目的：
#   画面に表示された情報を、このコマンド専用のキャッシュファイルに保存する
#   保存した内容は、標準出力が可能。また行数を指定することで、それだけを出力可能

# 使い方：
#   -n: 標準出力に行数を指定する
#   標準入力あり: 内容をキャッシュファイルに保存する（および、標準出力する）
#   行数指定: 指定された行だけを表示する
#   オプションなし: キャッシュを標準出力する

CACHE_FILE=~/.cache
TRUE=0
FALSE=1

usage() {
cat << EOF
  cache -- Pipeline cache --
  potion:
    -h: Help
    -n: Show cashe with line number
  usage:
    Cache the "hello":
      $ echo "hello\nhow\nare\nyou?" | ./cache.sh
      > hello
      > how
      > are
      > you?
    Show the cache with line number:
      $ ./cache.sh -n
      >    1 hello
      >    2 how
      >    3 are
      >    4 you?
    Show the specified line:
      $ ./cache.sh -n 1 3,4
      >    1 hello
      >    3 are
      >    4 you?
EOF
}

check() {
  [[ -w "$CACHE_FILE" ]] && return $TRUE
  return $FALSE
}

initialize() {
  touch $CACHE_FILE
}

error_exit() {
  echo "ERROR_EXIT" 1>&2
  exit 1
}

# 一時ファイル設定
tmpfile=$(mktemp)
function rm_tmpfile { [[ -f "$tmpfile" ]] && rm -f "$tmpfile" }
trap rm_tmpfile EXIT
trap 'trap - EXIT; rm_tmpfile; exit -1' INT PIPE TERM

# 初期化
check || initialize
check || error_exit

# オプション解析
H_FLAG=false
N_FLAG=false
LINE_OPTS=""
while getopts hn OPT
do
  case $OPT in
    "h" ) H_FLAG=true ;;
    "n" ) N_FLAG=true ;;
    * ) usage && exit 1;;
  esac
done
shift $(expr $OPTIND - 1)
[[ -n "$*" ]] && LINE_OPTS=`echo "$*" | sed -e 's/ /p;/g' -e 's/$/p;/'`

# usageを表示し終了
$H_FLAG && usage && exit 0

# 標準入力があった場合、それをキャッシュする
[[ -p /dev/stdin ]] && cat - > $CACHE_FILE

# 行数表示オプションが有効な場合、行数を付与する
$N_FLAG && nl -n rn -ba -s " " -w 4 $CACHE_FILE > $tmpfile || cat $CACHE_FILE > $tmpfile

# 行数指定があった場合、その行だけを出力
[[ -n "$LINE_OPTS" ]] && sed -n $LINE_OPTS $tmpfile || cat $tmpfile

exit 0
