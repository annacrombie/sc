#
"\(.username) (\(.plan))
tracks: \(.track_count) followers: \(.followers_count) \(
.description//""|if . != "" then
"
  \(.)"
else
  ""
end
)"
