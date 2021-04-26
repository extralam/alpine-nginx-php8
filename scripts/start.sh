#!/bin/bash

echo "Run custom scripts"

# Run custom scripts
if [[ "$RUN_SCRIPTS" == "1" ]] ; then
  if [ -d "/var/www/html/scripts/" ]; then
    # make scripts executable incase they aren't
    chmod -Rf 750 /var/www/html/scripts/*; sync;
    # run scripts in number order
    for i in `ls /var/www/html/scripts/`; do /var/www/html/scripts/$i ; done
  else
    echo "Can't find script directory"
  fi
fi


echo "Start supervisord and services"

# Start supervisord and services
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf