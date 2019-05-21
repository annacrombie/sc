def fromsctime:
  . | strptime("%Y/%m/%d %H:%M:%S %z")
;

def sctimestamp:
  . | fromsctime | strftime("%s") | tonumber
;

def lim:
  [.|if $limit == "x" then .[] else .[0:($limit|tonumber)][] end]
;

def obj_to_zsh:
  [
    to_entries[] |
      [
        [
          (.key | tostring),
          (.value | if type == "string" then . | @sh else . | tostring end)
        ] | join(" ")
      ] | join(" ")
  ] | join(" ")
;

def checkblank($rep):
  .//"" | if . == "" then rep else . end
;

def trim_paragraph:
  . | split("\n")[0][0:80]|checkblank(".")
;

def switch(uf; tf; pf):
  if .type == "user" then
    uf
  else if .type == "track" then
    tf
  else if .type == "plist" then
    pf
  else
    .
  end end end
;


def isclean:
  (._cleaned // false)
;

def clean_track:
  {
    "type":          "track",
    "id":            .id,
    "user_id":       .user.id,
    "permalink":     "\(.user.permalink)/\(.permalink)",
    "stream_url":    .stream_url,
    "plays":         .playback_count,
    "favoritings":   .favoritings_count,
    "comments":      .comment_count,
    "reposts":       .reposts_count,
    "desc":          .description | checkblank("<none>") | trim_paragraph,
    "last_modified": .created_at | sctimestamp,
    "downloadable":  .downloadable,
    "artist":        .user.username,
    "title":         .title,
    "ext":           "mp3",
    "_cleaned":      true
  }
;

def clean_user:
  {
    "type":          "user",
    "id":            .id,
    "permalink":     .permalink,
    "followers":     .followers_count,
    "username":      .username,
    "plan":          .plan,
    "desc":          .description | checkblank("<none>") | trim_paragraph,
    "tracks":        .track_count,
    "followers":     .followers_count,
    "last_modified": .last_modified | sctimestamp,
    "_cleaned":       true
  }
;

def clean:
  . | if isclean then
    .
  else
    ({ "type": .kind } + .) | switch(clean_user; clean_track; .)
  end
;

def track_nice:
  . | clean | [ .title, (.plays | tostring), .permalink ] | join("|")
;

def track_niced:
  [
    "type: track, permalink: \(.permalink)",
    "  \(.title)",
    "  \(.artist)",
    "  " + ([
      "plays \(.plays)",
      "<3 \(.favoritings)",
      "comments \(.comments)",
      "reposts \(.reposts)"
    ] | join(" / ")),
    "  " + .desc
  ] | join("\n")
;

def user_nice:
  [
    .username,
    .permalink,
    .plan,
    .desc
  ] | join("|")
;

def user_niced:
  [
    "type: user, permalink: \(.permalink)",
    "  \(.username)",
    "  " + ([
      "plan: \(.plan)",
      "tracks: \(.tracks)",
      "followers: \(.followers)"
    ] | join(" / ")),
    "  " + (.desc)
  ] | join("\n")
;

def display(nice; niced; raw; rawd):
  if $dkind == "nice" then
    if $dlvl == "desc" then
      niced
    else
      nice
    end
  else
    if $dlvl == "desc" then
      rawd
    else
      raw
    end
  end
;

def dplist:
  .
;

def dtrack:
  display(track_nice; track_niced; .; .)
;

def duser:
  display(user_nice; user_niced; .; .)
;

def tfilter(t):
  . | select(.type == t)
;

def dstream:
  . | switch(duser; dtrack; dplist)
;

def zstream:
  . | obj_to_zsh
;
