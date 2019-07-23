#col
import "mu_common" as mu;
"type|name|desc\n" +
([.] | flatten | mu::lim | [.[] |
  mu::switch(
    ["user", .username, .desc];
    ["track", .title,   .desc];
    ["plist", "", ""]
  ) | join("|")
] | join("\n"))
