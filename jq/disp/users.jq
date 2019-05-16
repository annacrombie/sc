#username,permalink,pro?,desc
[.[]
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
