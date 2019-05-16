[.|if $limit == "" then .[] else .[0:($limit|tonumber)][] end]
  |[.[] | "user_id \(.id)"]|join("\n")
