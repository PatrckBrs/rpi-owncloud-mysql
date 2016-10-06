#!/bin/bash
MEM="memcache.local"

if [ -f "/var/www/owncloud/config/config.php" ]
then
if  [ -z "$MEM" ]
then
  sed -i '/^);/i\  '"'memcache.local' => '\\\\OC\\\\Memcache\\\\APCu'," /var/www/owncloud/config/config.php
  fi
fi
/usr/bin/supervisord -n -c /etc/supervisord.conf
