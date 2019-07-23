# mu

A lightweight client for music streaming services

```sh
$ mu resolve earthlibraries | mu followers | mu -t 2 filter '.plan != "Pro"' | mu describe
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
$ mu r tennysonmusic | mu tracks | mu -t 3 sort plays desc
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
$ mu_prefix=~/.local/share
$ mkdir -p $mu_prefix
$ git clone --recurse-submodules <repo> $mu_prefix/mu
$ sudo make -C $mu_prefix/mu install
```

### `~/.config/mu/config.zsh`

```zsh
export SOUNDCLOUD_CLIENT_ID="<your client id>"
```

# Usage

```zsh
$ mu -h
```
