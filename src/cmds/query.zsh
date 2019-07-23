#create a query object

cmd_query_() {
  to_json_ type query query "$mu_trailing" _cleaned true |
    if [[ $mu_tty ]]; then
      jq_ s ". | mu::query_nice | mu::to_table" -
    else
      cat -
    fi
}
