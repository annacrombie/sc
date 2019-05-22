#col
import "sc_common" as sc;
"title|plays|permalink\n" +
([.] | flatten | sc::lim | [.[] | sc::track_nice] | join("\n"))
