#username,permalink,pro?,desc
[.[0:($limit|tonumber)][]
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
