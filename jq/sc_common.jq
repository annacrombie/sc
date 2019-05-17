def fromsctime:
  .|strptime("%Y/%m/%d %H:%M:%S %z")
;

def sctimestamp:
  .|fromsctime|strftime("%s")
;

def lim:
  [.|if $limit == "" then .[] else .[0:($limit|tonumber)][] end]
;

def obj_to_zsh:
  [to_entries[] | [[.key, .value][] | tostring]|join(" ")]|join(" ")
;

def checkblank($rep):
  .//"" | if . == "" then rep else . end
;

def trim_paragraph:
  . | split("\n")[0][0:80]|checkblank(".")
;

def track_nice:
  [
    .title,
    "\(.user.permalink)/\(.permalink)"
  ] | join("|")
;

def clr(num):
  "\u001b[\(num)m"
;

def track_niced:
  [
    "type: track, permalink: \(.user.permalink)/\(.permalink)",
    "  \(.title)",
    "  \(.user.username)",
    "  " + ([
      "plays \(.playback_count)",
      "<3 \(.favoritings_count)",
      "comments \(.comment_count)",
      "reposts \(.reposts_count)"
    ] | join(" / ")),
    "  " + .description | checkblank("<none>") | trim_paragraph
  ] | join("\n")
;

def track_raw:
  {
    "type": "track",
    "id":   .id
  } | obj_to_zsh
;

def track_rawd:
  {
    "type":          "track",
    "id":            .id,
    "stream_url":    .stream_url | @sh,
    "plays":         .playback_count,
    "last_modified": .created_at | sctimestamp,
    "downloadable":  .downloadable,
    "artist":        .user.username | @sh,
    "title":         .title | @sh,
    "ext":           "mp3"
  } | obj_to_zsh
;

def user_nice:
  [
    .username,
    .permalink,
    .plan,
    .description | checkblank("<none>") | trim_paragraph
  ]|join("|")
;

def user_niced:
  [
    "type: user, permalink: \(.permalink)",
    "  \(.username)",
    "  " + ([
      "plan: \(.plan)",
      "tracks: \(.track_count)",
      "followers: \(.followers_count)"
    ] | join(" / ")),
    "  " + (.description | checkblank("<none>") | trim_paragraph)
  ] | join("\n")
;

def user_raw:
  {
    "type": "user",
    "id":   .id
  } | obj_to_zsh
;

def user_rawd:
  {
    "type":          "user",
    "id":            .id,
    "followers":     .followers_count,
    "username":      .username | @sh,
    "last_modified": .last_modified | sctimestamp
  } | obj_to_zsh
;
