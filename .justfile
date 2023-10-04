TEAL_FILES := `git ls-files **/*.tl`

alias s := setup
setup:
  #! /usr/bin/env fish
  command -v funzzy || cargo install funzzy
  command -v tl || sudo luarocks install tl
  command -v cyan || sudo luarocks install cyan
  echo "
    #!/usr/bin/env bash
    just check && exit 0 || echo 'Please fix the errors above before committing' 
    exit 1
  " > .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit

alias e := edit
edit:
  nvim --cmd 'set rtp+=.'

alias b := build
build:
  cyan build

alias wb := watch-build
watch-build:
  echo "{{TEAL_FILES}}" | funzzy 'just build'

alias c := check
check:
  cyan check {{TEAL_FILES}}

alias wc := watch-check
watch-check:
  echo "{{TEAL_FILES}}" | funzzy 'just check'
