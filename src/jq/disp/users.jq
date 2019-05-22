#col
import "sc_common" as sc;
"username|permalink|pro?|desc\n" +
([.] | flatten | sc::lim | [.[] | sc::user_nice] | join("\n"))
