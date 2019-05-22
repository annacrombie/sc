# sc

A lightweight soundcloud client, conforming to unix philosophy.

```sh
$ sc resolve earthlibraries | sc followers | sc -t 2 filter '.plan != "Pro"' | sc describe

type: user, permalink: flusnoix_jemawa
  jemawa
  plan: Free / tracks: 8 / followers: 135
  &gt;&gt;**^**&lt;&lt;
type: user, permalink: sister-sniffle
  Sister Sniffle
  plan: Free / tracks: 24 / followers: 57
  Indie Pop
```

```sh
$ sc r tennysonmusic | sc tracks | sc -t 3 sort plays desc
type   name       desc
track  All Yours  happily confused
track  Cry Bird   First single off our upcoming EP, "Uh Oh!".
track  7:00 AM    Tennyson on Yours Truly! yourstru.ly/stories/tennyson
```

# Installation

## Requirements

+ find (GNU findutils) 4.6.0 - only for the `prune` command
+ git version 2.21.0
+ GNU coreutils (mktemp...)
+ jq-1.5
+ tree v1.7.0 - only for the `library` command
+ zsh 5.6.2 (i686-pc-linux-gnu)
+ column

```
$ sc_prefix=~/.local/share
$ mkdir -p $sc_prefix
$ git clone --recurse-submodules <repo> $sc_prefix/sc
$ sudo make -C $sc_prefix/sc install
```

### `~/.config/sc/config.zsh`

```zsh
export SOUNDCLOUD_CLIENT_ID="<your client id>"
```

# Usage

```zsh
$ sc -h
```
