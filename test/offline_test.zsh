typeset -g config="test/cfg/offline.zsh"
typeset -g cache="test/data/offline"

typeset -g user=earthlibraries
typeset -a tests=(
  "mu resolve $user | jq -Mr '.followers'"
  =
  18

  "mu r $user | mu d | jq -Mr '.type'"
  "=~"
  user

  "mu r $user | mu --force-tty-out d"
  "=~"
  'type: user, permalink: earthlibraries
  Earth Libraries
  plan: Free / tracks: 19 / followers: 18
  Hello Stuff Explorer! Welcome to Earth Libraries! A recently rediscovered govern'

  "mu r $user | mu t | mu c"
  =
  8

  "mu r $user | mu --force-tty-out -t 1 t"
  =
  'permalink                                plays  title
earthlibraries/dommel-mossel-marco-polo  2      Dommel Mossel - Marco Polo'

  "mu r $user | mu followers | mu c"
  =
  13

  "mu r $user | mu followings | mu c"
  =
  25

  "mu r $user | mu t | mu u | mu t | mu u | jq -Mr '.permalink'"
  =
  "$user"

  "mu r $user | mu t | mu -t 1 sort plays | jq -Mr '.permalink'"
  =
  "$user/liquid-damage"

  "mu r $user | mu t | mu filter '.title[0:7] == \"Captain\"' | mu c"
  =
  2

  "mu resolve earthlibraries | mu followers | mu -t 2 filter '.plan != \"Pro\"' | mu --force-tty-out describe"
  =
  'type: user, permalink: flusnoix_jemawa
  jemawa
  plan: Free / tracks: 8 / followers: 135
  &gt;&gt;**^**&lt;&lt;
type: user, permalink: sister-sniffle
  Sister Sniffle
  plan: Free / tracks: 24 / followers: 57
  Indie Pop'

  "mu r tennysonmusic | mu tracks | mu --force-tty-out -t 3 sort plays desc"
  =
  'type   name        desc
track  With You    7" vinyl order:
track  Lay-by      hey. i hope this song reminds you to slow down. sometimes the dark can be beauti
track  Like What?  Tennyson on Yours Truly! yourstru.ly/stories/tennyson'
)
