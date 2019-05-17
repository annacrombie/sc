optparse_disp[banner]="Usage: sc [OPTIONS] COMMAND [QUERY]"
optparse_disp[desc]="A lightweight soundcloud client, conforming to unix philosophy."
optparse_disp[info]='
COMMANDS
  d, describe   - describe input object(s), or re-run after resolve Q
  f, fetch    Q - download input object(s), or re-run after resolve Q | tracks
  t, tracks   Q - get tracks from input, or query Q
  u, users    Q - get users from input, or query Q
  p, play       - play input files with mpv(1)
  r, resolve  Q - resolve Q to an object
  l, library    - display downloaded tracks

OBJECTS
  Many sc commands take input as objects and/or output objects.  An object is
  either a track, user, or playlist.  This allows sc commands to be chained
  like so:

    sc resolve <artist> | sc --take=5 tracks  | sc fetch | sc play

  This will resolve the input string to an artist id, get a list of their tracks
  (outputting only 5), fetch those tracks, and finally play the result.

CACHE
  sc internally uses wcache(1) which is a thin wrapper around wget(1) that
  caches downloads for relatively long periods of time.  For this reason,
  repeated sc querys will not touch the network.

  If I first run (getting the first track for an artist)

    sc -t 1 users tennyson | sc -t 1 tracks | sc describe

  And then run

    sc -t 1 users tennyson | sc -t 1 tracks | sc fetch

  Only the final pipe touches the network, since all necessarry metadata has
  already been fetched.'
