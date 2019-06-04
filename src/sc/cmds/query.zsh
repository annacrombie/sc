#create a query object

cmd_query_() {
  to_json_ type query query "$sc_trailing" _cleaned true |
    if [[ $sc_tty ]]; then
      jq_ s ". | sc::query_nice | sc::to_table" -
    else
      cat -
    fi
}
