typeset -g config="test/cfg/offline.zsh"
typeset -g cache="test/data/offline"

typeset -g user=earthlibraries
typeset -a tests=(
  "sc resolve $user | jq -Mr '.followers'"
  =
  15

  "sc r $user | sc d | jq -Mr '.type'"
  "=~"
  user

  "sc r $user | sc --force-tty-out d"
  "=~"
  'type: user, permalink: earthlibraries
  Earth Libraries
  plan: Free / tracks: 8 / followers: 15
  Hello Stuff Explorer! Welcome to Earth Libraries! A recently rediscovered govern'

  "sc r $user | sc t | sc c"
  =
  8

  "sc r $user | sc --force-tty-out -t 1 t"
  =
  'permalink                                plays  title
earthlibraries/dommel-mossel-marco-polo  2      Dommel Mossel - Marco Polo'

  "sc r $user | sc followers | sc c"
  =
  13

  "sc r $user | sc followings | sc c"
  =
  25

  "sc r $user | sc t | sc u | sc t | sc u | jq -Mr '.permalink'"
  =
  "$user"

  "sc r $user | sc t | sc -t 1 sort plays | jq -Mr '.permalink'"
  =
  "$user/liquid-damage"

  "sc r $user | sc t | sc filter '.title[0:7] == \"Captain\"' | sc c"
  =
  2

  "sc resolve earthlibraries | sc followers | sc -t 2 filter '.plan != \"Pro\"' | sc --force-tty-out describe"
  =
  'type: user, permalink: flusnoix_jemawa
  jemawa
  plan: Free / tracks: 8 / followers: 135
  &gt;&gt;**^**&lt;&lt;
type: user, permalink: sister-sniffle
  Sister Sniffle
  plan: Free / tracks: 24 / followers: 57
  Indie Pop'

  "sc r tennysonmusic | sc tracks | sc --force-tty-out -t 3 sort plays desc"
  =
  'type   name        desc
track  With You    7" vinyl order:
track  Lay-by      hey. i hope this song reminds you to slow down. sometimes the dark can be beauti
track  Like What?  Tennyson on Yours Truly! yourstru.ly/stories/tennyson'
)
