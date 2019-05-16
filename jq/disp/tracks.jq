#title,permalink
[.[0:($limit|tonumber)][]
  | [.title,"\(.user.permalink)/\(.permalink)"] | join("|")]
  | join("\n")
