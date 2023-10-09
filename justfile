hello:
  echo "HELLO WORLD"
  sleep 1s
  echo "BYE"

check:
  luacheck lua/*.lua lua/**/*.lua

watch:
  funzzy watch just check
