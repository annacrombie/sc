sc_() {
  sc --config="test/cfg/offline.zsh" --cache="test/data" $@
}

typeset -g user=earthlibraries
typeset -a tests=(
  "sc_ resolve $user | jq -Mr '.followers'"
  =
  15

  "sc_ r $user | sc_ d | jq -Mr '.type'"
  "=~"
  user

  "sc_ r $user | sc_ --force-tty-out d"
  "=~"
  'type: user, permalink: earthlibraries
  Earth Libraries
  plan: Free / tracks: 8 / followers: 15
  Hello Stuff Explorer! Welcome to Earth Libraries! A recently rediscovered govern'

  "sc_ r $user | sc_ t | sc_ c"
  =
  8

  "sc_ r $user | sc_ --force-tty-out -t 1 t"
  =
  'title                       plays  permalink
Dommel Mossel - Marco Polo  2      earthlibraries/dommel-mossel-marco-polo'

  "sc_ r $user | sc_ followers | sc_ c"
  =
  13

  "sc_ r $user | sc_ followings | sc_ c"
  =
  25

  "sc_ r $user | sc_ t | sc_ u | sc_ t | sc_ u | jq -Mr '.permalink'"
  =
  "$user"

  "sc_ r $user | sc_ t | sc_ -t 1 sort plays | jq -Mr '.permalink'"
  =
  "$user/liquid-damage"

  "sc_ r $user | sc_ t | sc_ filter '.title[0:7] == \"Captain\"' | sc_ c"
  =
  2

  "sc_ resolve earthlibraries | sc_ followers | sc_ -t 2 filter '.plan != \"Pro\"' | sc_ --force-tty-out describe"
  =
  'type: user, permalink: flusnoix_jemawa
  jemawa
  plan: Free / tracks: 8 / followers: 135
  &gt;&gt;**^**&lt;&lt;
type: user, permalink: sister-sniffle
  Sister Sniffle
  plan: Free / tracks: 24 / followers: 57
  Indie Pop'

  "sc_ r tennysonmusic | sc_ tracks | sc_ --force-tty-out -t 3 sort plays desc"
  =
  'type   name        desc
track  With You    7" vinyl order:
track  Lay-by      hey. i hope this song reminds you to slow down. sometimes the dark can be beauti
track  Like What?  Tennyson on Yours Truly! yourstru.ly/stories/tennyson'
)

typeset test comp expected
for test comp expected in $tests; do
  echo -n "$test "

  typeset res=$(eval "$test")
  eval "[[ \"${res//\"/\\\"/}\" $comp \"${expected//\"/\\\"/}\" ]]"

  if [[ $? -ne 0 ]]; then
    echo "\e[31mfailed\e[0m :("
    echo "'$res' does not $comp '$expected'"
    exit 1
  else
    echo "\e[32mpassed\e[0m"
  fi
done
