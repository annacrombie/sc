#username,permalink,pro?,desc
import "sc_common" as sc;
.|sc::lim|[.[] | sc::user_nice]|join("\n")
