#title,permalink
[.|if $limit == "" then .[] else .[0:($limit|tonumber)][] end]
  | [ .[] | [.title,"\(.user.permalink)/\(.permalink)"] | join("|")]
  | join("\n")
