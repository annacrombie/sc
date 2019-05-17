#title,permalink
import "sc_common" as sc;
.|sc::lim | [ .[] | [.title,"\(.user.permalink)/\(.permalink)"] | join("|")]
  | join("\n")
