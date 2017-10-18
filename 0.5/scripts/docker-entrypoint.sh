#!/bin/sh
# Deluged entrypoint
# Using ENV set at "docker run -e"
# or "docker create -e"
# info@sinaptika.net

set -e

export TZ=${TZ}

rm -f ${D_DIR}/config/deluged.pid

AUTH_UID=$(stat -c %u ${D_DIR}/config/auth)

if [ ${D_UID} != ${AUTH_UID} ]
then
 apk add --no-cache shadow
 usermod -u ${D_UID} ${D_USER}
 groupmod -g ${D_GID} ${D_GROUP}
 apk del shadow
 chown -R ${D_UID}:${D_GID} ${D_DIR}
 echo ${D_UID}:${D_GID} >> ${D_DIR}/config/deluge-user-id
 echo "File permissions set"
else
 echo "Starting Deluged"
fi

exec supervisord -c ${D_DIR}/config/supervisord.conf
