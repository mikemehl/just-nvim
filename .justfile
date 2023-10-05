set shell := ["fish", "-c"]
TEAL_FILES := `git ls-files **/*.tl`

alias s := setup
setup:
  #! /usr/bin/env fish
  command -v funzzy || cargo install funzzy
  command -v tl || sudo luarocks install tl
  command -v cyan || sudo luarocks install cyan

alias e := edit
edit:
  nvim --cmd 'set rtp+=./lua/?.lua'

alias b := build
build:
  cyan build

alias wb := watch-build
watch-build:
  echo "{{TEAL_FILES}}" | funzzy -n 'just build'

alias c := check
check:
  cyan check **/*.tl

alias wc := watch-check
watch-check:
  echo "{{TEAL_FILES}}" | funzzy -n 'just check'
