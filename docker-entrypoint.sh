#!/bin/bash
MEM=$(grep memcache /var/www/owncloud/config/config.php  | wc -l)

if [ -f "/var/www/owncloud/config/config.php" ]
then
if  [[ "$MEM" -eq "0" ]]
then
  sed -i '/^);/i\  '"'memcache.local' => '\\\\OC\\\\Memcache\\\\APCu'," /var/www
/owncloud/config/config.php
else
echo "OK"
  fi
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf
