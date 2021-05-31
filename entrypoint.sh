#!/bin/bash
set -e

# set env vars to defaults if not already set
if [ -z "$LOG_LEVEL" ]; then
  export LOG_LEVEL=warn
fi

if [ -z "$LOG_FORMAT" ]; then
  export LOG_FORMAT="%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\" %D"
fi

if [ -z "$REMOTE_PATH" ]; then
  export REMOTE_PATH=remote
fi

# validate required variables are set
if [ -z "$USP_LICENSE_KEY" ]; then
  echo >&2 "Error: USP_LICENSE_KEY environment variable is required but not set."
  exit 1
fi

# update configuration based on env vars
# log levels
/bin/sed "s@{{LOG_LEVEL}}@${LOG_LEVEL}@g; s@{{LOG_FORMAT}}@'${LOG_FORMAT}'@g;" /etc/apache2/sites-enabled/unified-origin.conf > /etc/apache2/sites-enabled/unified-origin.conf

# # transcode
# if [ $TRANSCODE_PATH ] && [ $TRANSCODE_URL ]; then  
#   /bin/sed "s@{{TRANSCODE_PATH}}@${TRANSCODE_PATH}@g; s@{{TRANSCODE_URL}}@${TRANSCODE_URL}@g; s@{{REMOTE_STORAGE_URL}}@${REMOTE_STORAGE_URL}@g" /etc/apache2/sites-enabled/transcode.conf.in >/etc/apache2/sites-enabled/transcode.conf
# fi

# USP license
echo $USP_LICENSE_KEY >/etc/usp-license.key

#Enable modules
a2enmod proxy
a2enmod ssl

rm -f /run/apache2/httpd.pid

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- /usr/sbin/apache2ctl "$@"
fi

exec "$@"
