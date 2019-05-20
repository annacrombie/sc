#title,permalink
import "sc_common" as sc;
[.] | flatten | sc::lim | [.[] | sc::track_nice] | join("\n")
