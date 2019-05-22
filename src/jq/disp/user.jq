#col
import "sc_common" as sc;
"username|permalink|pro?|desc\n" +
(. | sc::user_nice)
