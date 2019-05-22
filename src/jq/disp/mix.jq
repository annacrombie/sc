#col
import "sc_common" as sc;
"type|name|desc\n" +
([.] | flatten | sc::lim | [.[] |
  sc::switch(
    ["user", .username, .desc];
    ["track", .title,   .desc];
    ["plist", "", ""]
  ) | join("|")
] | join("\n"))
