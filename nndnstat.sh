#!/bin/sh
#SSH to any node on your Isilon cluster and run: sh nndnstat.sh 
#Usefull to ensure namenode and datanode loadbalancing on Isilon Cluster.  Easy to spot network issues on nodes.

while true
do
  date -u
  isi_for_array "echo \`netstat -an | grep 8020 |  grep 'ESTABLISHED' | wc -l\` NN, \`netstat -an | grep 1021 |  grep 'ESTABLISHED' | wc -l\` DN" | sort
  sleep 5
 echo ""
done
