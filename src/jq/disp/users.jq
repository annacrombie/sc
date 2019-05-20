#username,permalink,pro?,desc
import "sc_common" as sc;
[.] | flatten | unique | sc::lim | [.[] | sc::user_nice] | join("\n")
