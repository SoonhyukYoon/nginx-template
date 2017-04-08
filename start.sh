#!/bin/sh

SETUSER="root"
RUNNER=`whoami`

if [ $RUNNER != $SETUSER ] ;
   then echo "Deny Access : [ $RUNNER ]. Not $SETUSER" ;
   exit 0 ;
fi

ps_check(){
 ps -ef | grep nginx | grep "master process" | wc -l
}

[ `ps_check` -gt 0 ] && echo "##### ERROR. Nginx is already running. exiting.. #####" && exit 1

## Environment Variables
export NGINX_HOME=/engn001/emsadm/nginx/nginx-1.10.2
export NGINX_CONF=/engn001/emsadm/nginx/nginx-1.10.2/conf/nginx.conf
export NGINX_PID=${NGINX_HOME}/logs/nginx.pid

# Run Nginx
${NGINX_HOME}/sbin/nginx -c ${NGINX_CONF}

retryCnt=0
while [ ! -f $NGINX_PID ]
do
	sleep 0.5
	((retryCnt++))
	if [ $retryCnt -gt 3 ] ;
	    then echo "[ERROR] Nginx Boot Failed!"
	    exit 0 ;
	fi
done
echo "[INFO] Nginx Booted!"

