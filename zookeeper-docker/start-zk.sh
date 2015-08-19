if [ -z "$ZK_ID" ] ; then
  echo 'No server ID specified, trying to extract from hostname'
  export ZK_ID=$(docker inspect `hostname` | jq --raw-output '.[0] | .Name' | awk -F_ '{print $3}')
fi

#cat $ZK_HOME/conf/zoo.cfg

#echo "CONFIG START"

sed -i -r 's|#(log4j.appender.ROLLINGFILE.MaxBackupIndex.*)|\1|g' $ZK_HOME/conf/log4j.properties
sed -i -r 's|#autopurge|autopurge|g' $ZK_HOME/conf/zoo.cfg


if [ -n "$ZK_NODES" ] ; then
	export count=1
	for node in $ZK_NODES
	do
		if [ "$ZK_ID" -eq "$count" ]; then
			
			echo "server.$count=0.0.0.0:2888:3888" >> $ZK_HOME/conf/zoo.cfg
		else
		#if egrep -q "(^|^#)server\.\d+=" $ZK_HOME/conf/zoo.cfg; then
		#    sed -r -i "s@(^|^#)(server\.\d+)=(.*)@\2=$node:2888:3888@g" $ZK_HOME/conf/zoo.cfg #note that no config values may contain an '@' char
		#else
			echo "server.$count=$node:2888:3888" >> $ZK_HOME/conf/zoo.cfg
		fi
		#fi
		count=$(($count+1))
	done
	unset count
fi

#echo "CONFIG DONE"
#cat $ZK_HOME/conf/zoo.cfg

echo "$ZK_ID" > /var/lib/zookeeper/myid

echo "Starting zookeeper server $(cat /var/lib/zookeeper/myid)"

/opt/zookeeper-3.4.6/bin/zkServer.sh start-foreground