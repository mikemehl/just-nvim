edit:
  nvim --cmd 'set rtp+=.'

build:
  nvim -Es --headless --cmd 'set rtp+=.' --cmd 'TealBuild'
