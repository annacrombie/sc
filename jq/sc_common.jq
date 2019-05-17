def fromsctime:
  .|strptime("%Y/%m/%d %H:%M:%S %z")
;

def sctimestamp:
  .|fromsctime|strftime("%s")
;

def lim:
  [.|if $limit == "" then .[] else .[0:($limit|tonumber)][] end]
;

def track_nice:
  [.title,"\(.user.permalink)/\(.permalink)"] | join("|")
;

def track_niced:
  "\(.user.username) - \(.title)
  > \(.playback_count) / <3 \(.favoritings_count) / [] \(.comment_count) / ⟳ \(.reposts_count)

  \(.description)

  \(.created_at)
  \(.user.permalink)/\(.permalink)"
;

def track_raw:
  "track_id \(.id)"
;

def track_rawd:
  "track_id \(.id) stream_url \(.stream_url | @sh) artist \(.user.username | @sh) title \(.title | @sh) ext mp3"
;

def user_nice:
  [.username, .permalink,
    if .plan == "Pro" then
      "*"
    else
      "x"
    end,
    (.description//"<empty>"|split("\n")[0][0:25])
  ]|join("|")
;

def user_niced:
  "\(.username) (\(.plan))
  tracks: \(.track_count) followers: \(.followers_count) \(
  .description//""|if . != "" then
  "
    \(.)"
  else
    ""
  end
  )"
;

def user_raw:
  "user_id \(.id)"
;

def user_rawd:
  "user_id \(.id) followers \(.followers_count) username \(.username | @sh) last_modified \(.last_modified|sctimestamp)"
;
