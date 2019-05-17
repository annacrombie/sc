#username,permalink,pro?,desc
import "sc_common" as sc;
.|sc::lim
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
