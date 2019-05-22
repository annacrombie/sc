# sc
[![Build Status](https://travis-ci.org/annacrombie/sc.svg?branch=master)](https://travis-ci.org/annacrombie/sc)

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
type   name        desc
track  With You    7" vinyl order:
track  Lay-by      hey. i hope this song reminds you to slow down. sometimes the dark can be beauti
track  Like What?  Tennyson on Yours Truly! yourstru.ly/stories/tennyson
```

# Installation

## Requirements

+ GNU coreutils (mktemp, ln...)
+ column
+ jq-1.5
+ zsh 5.6.2 (i686-pc-linux-gnu)
+ find (GNU findutils) 4.6.0 - only for the `prune` command
+ tree v1.7.0 - only for the `library` command

Also a soundcloud `CLIENT_ID` is required, you can get one by following [these
instructions](https://github.com/Soundnode/soundnode-app#configuration).

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
