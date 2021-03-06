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
  ._cleaned // false
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
    "go":            (.monetization_model == "SUB_HIGH_TIER"),
    "img":           (if .artwork_url then .artwork_url | split("large") | join("t500x500") else null end),
    "dur":           .duration,
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
    "img":           (if .avatar_url then .avatar_url | split("large") | join("t500x500") else null end),
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

def to_table:
  [.] | flatten | (
    ([.[0]|keys]) + [.[] | to_entries|[.[] | (.value|tostring)]]
  ) | [.[] | join("|")] | join("\n")
;

def is_ele(arr):
  . as $val | arr | any(. == $val)
;

def filter_keys(ks):
  . | to_entries | [.[] | select(.key | is_ele(ks))] | from_entries
;

def query_nice:
  . | clean | filter_keys(["query"])
;

def track_nice:
  . | clean | filter_keys(["title", "plays", "permalink"])
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
  . | clean | filter_keys(["username", "permalink", "plan", "desc"])
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
