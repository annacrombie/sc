jq -Mc '.' "test/data/offline/cache/api.soundcloud.com/users/100787952\$" && \
echo "column|output|is\nvery|very|cool" | column -s '|' -t && \
tmp=$(mktemp) && \
[[ -f "$tmp" ]] && echo "made temp file!" && rm "$tmp"
