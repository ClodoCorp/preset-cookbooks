#!/bin/bash
MYSQL_HOST=""
MYSQL_PORT=""
MYSQL_USER=""
MYSQL_PASS=""
MYSQL_DB=""

for var in $(grep -E '^gmysql-' /etc/powerdns/pdns.d/pdns.local.gmysql); do
  key=$(echo $var | awk -F "=" '{print $1}')
  val=$(echo $var | awk -F "=" '{print $2}')
  case $key in
    gmysql-host)
	    export MYSQL_HOST=$(echo $val)
      ;;
    gmysql-port)
	    export MYSQL_PORT=$(echo $val)
      ;;
    gmysql-dbname)
	    export MYSQL_DB=$(echo $val)
      ;;
    gmysql-user)
	    export MYSQL_USER=$(echo $val)
      ;;
    gmysql-password)
	    export MYSQL_PASS=$(echo $val)
      ;;
  esac
done

DOMAINS=$(grep 'produced a NS record' /var/log/pdns | awk '{print $10}' | cut -d\' -f2 | sort | uniq | grep -v NS)
MYSQL="/usr/bin/mysql -u${MYSQL_USER} -p${MYSQL_PASS} -h${MYSQL_HOST} -D${MYSQL_DB} -N"
for DOMAIN in $DOMAINS; do
    echo "Delete domain ${DOMAIN}" 
    DOMAIN_ID=$(echo "select from domains where name ='"${DOMAIN}"';"| $MYSQL)
    echo "delete from domains where name='"${DOMAIN}"';" | $MYSQL
    echo "delete from records where domain_id='"${DOMAIN_ID}"';" | $MYSQL
    echo "delete from records where name='"${DOMAIN}"';" | $MYSQL
done
pdns_control rediscover
echo -n > /var/log/pdns
service rsyslog reload

