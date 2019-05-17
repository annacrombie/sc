import "sc_common" as sc;
"user_id \(.id) followers \(.followers_count) username \(.username | @sh) last_modified \(.last_modified|sc::sctimestamp)"
