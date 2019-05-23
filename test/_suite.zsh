typeset -g failed
typeset -g config cache
typeset -ga tests


run_tests_() {
  typeset test comp expected
  for test comp expected in $tests; do
    echo -n "$test "

    typeset res=$(eval "$test")
    eval "[[ \"${res//\"/\\\"/}\" $comp \"${expected//\"/\\\"/}\" ]]"

    if [[ $? -ne 0 ]]; then
      echo "\e[31mfailed\e[0m :("
      echo "'$res' does not $comp '$expected'"
      failed=true
    else
      echo "\e[32mpassed\e[0m"
    fi
  done
}

for file in test/*_test.zsh; do
  echo "running ${${file:t}##.zsh}"
  source "$file"
  alias sc="sc --config=$config --cache=$cache"
  run_tests_

  tests=() config='' cache=''
done

if [[  $failed ]]; then
  echo "tests failed"
  exit 1
else
  exit 0
fi
