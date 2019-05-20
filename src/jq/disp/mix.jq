#type,name,desc
import "sc_common" as sc;
[.] | flatten | unique | sc::lim | [.[] |
  sc::switch(
    ["user", .username, .desc];
    ["track", .title,   .desc];
    ["plist", "", ""]
  ) | join("|")
] | join("\n")
