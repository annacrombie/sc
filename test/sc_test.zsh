sc_offline_() {
  sc --config="test/cfg/config.zsh" --cache="test/data" $@
}

typeset user=earthlibraries
typeset res
res="$(sc_offline_ resolve $user | jq -Mr '.followers')"
[[ $res = 15 ]] || exit 1

res="$(sc_offline_ r $user | sc d | jq -Mr '.type')"
[[ $res =~ "user" ]] || exit 1

res="$(sc_offline_ r $user | sc d | jq -Mr '.type')"
[[ $res =~ "user" ]] || exit 1

res="$(sc_offline_ r $user | sc t | sc c)"
[[ $res = 8 ]] || exit 1

res="$(sc_offline_ r $user | sc followers | sc c)"
[[ $res = 13 ]] || exit 1

res="$(sc_offline_ r $user | sc followings | sc c)"
[[ $res = 25 ]] || exit 1

res="$(sc_offline_ r $user | sc t | sc u | sc t | sc u | jq -Mr '.permalink')"
[[ $res = "$user" ]] || exit 1

res="$(sc_offline_ r $user | sc t | sc -t 1 sort plays | jq -Mr '.permalink')"
[[ $res = "$user/liquid-damage" ]] || exit 1

res="$(sc_offline_ r $user | sc t | sc filter '.title[0:7] == "Captain"' | sc c)"
[[ $res = 2 ]] || exit 1

echo "all tests passed"
exit 0
