#username,permalink,pro?,desc
[.|if $limit == "" then .[] else .[0:($limit|tonumber)][] end]
  |[.[]
    | [.username,
       .permalink,
       if .plan == "Pro" then
         "*"
       else
         ""
       end,
       (.description//"<empty>"|split("\n")[0][0:25])]
       | join("|")]
    | join("\n")
