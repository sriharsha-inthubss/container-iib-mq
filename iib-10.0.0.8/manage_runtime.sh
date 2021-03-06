#!/bin/bash

set -e

NODE_NAME=${NODENAME-IIBV10NODE}

stop()
{
	echo "----------------------------------------"
	echo "Stopping node $NODE_NAME..."
	mqsistop $NODE_NAME
}

start()
{
	echo "----------------------------------------"
		/opt/ibm/iib-10.0.0.8/iib version
	echo "----------------------------------------"

	NODE_EXISTS=`mqsilist | grep $NODE_NAME > /dev/null ; echo $?`

	if [ ${NODE_EXISTS} -ne 0 ]; then
    echo "----------------------------------------"
    echo "Node $NODE_NAME does not exist..."
    echo "Creating node $NODE_NAME"
		mqsicreatebroker $NODE_NAME
    echo "----------------------------------------"
	fi
	echo "----------------------------------------"
	echo "Starting syslog"
	sudo /usr/sbin/rsyslogd
	echo "Starting node $NODE_NAME"
		mqsistart $NODE_NAME
	echo "----------------------------------------"
}

monitor()
{
	echo "----------------------------------------"
	echo "Running - stop container to exit"
	# Loop forever by default - container must be stopped manually.
	# Here is where you can add in conditions controlling when your container will exit - e.g. check for existence of specific processes stopping or errors beiing reported
	while true; do
		sleep 1
	done
}

check_license.sh
start
trap stop SIGTERM SIGINT
monitor
