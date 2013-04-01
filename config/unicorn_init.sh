#!/bin/sh
#
# chkconfig:   - 85 15 
# description: Unicorn server for chewbacon.com
# processname: unicorn
#

set -e

APP_ROOT=/var/www/sites/weight/current
APP_ENV=production

PID=$APP_ROOT/tmp/pids/unicorn.pid
OLD_PID="$PID.oldbin"

CMD="cd $APP_ROOT; bundle exec unicorn -D -c $APP_ROOT/config/unicorn.rb -E $APP_ENV"
AS_USER=deploy

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
  test -s $OLD_PID && kill -$1 `cat $OLD_PID`
}

run () {
  if [ "$(id -un)" = "$AS_USER" ]; then
    eval $1
  else
    su -c "$1" - $AS_USER
  fi
}

case $1 in
  start)
    sig 0 && echo >&2 "Already running" && exit 0
    echo "Starting"
    run "$CMD"
    ;;
  stop)
    sig QUIT && echo "Stopping" && exit 0
    echo >&2 "Not running"
    ;;  
  force-stop)
    sig TERM && echo "Forcing a stop" && exit 0
    echo >&2 "Not running"
    ;;  
  restart|reload)
    sig USR2 && sleep 5 && oldsig QUIT && echo "Killing old master" `cat $OLD_PID` && exit 0
    echo >&2 "Couldn't reload, starting '$CMD' instead"
    run "$CMD"
    ;;  
  upgrade)
    sig USR2 && echo Upgraded && exit 0
    echo >&2 "Couldn't upgrade, starting '$CMD' instead"
    run "$CMD"
    ;;  
  rotate)
    sig USR1 && echo rotated logs OK && exit 0
    echo >&2 "Couldn't rotate logs" && exit 1
    ;;  
  *)  
    echo >&2 "Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"
    exit 1
    ;;  
esac
