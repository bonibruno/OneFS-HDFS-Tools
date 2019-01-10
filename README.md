# OneFS-HDFS-Tools
OneFS HDFS Scripts:

nndnstat.sh - shows namenode and datanode connections on Isilon.
tcptune.sh - tunning script to improve HDFS performance.  Use either Max, Half or Default and test.
check-syslog.sh - dumps syslog configuration info for easy review.  

To run any script, just login as root on Isilon, copy the script and make it executable, then run "sh script-name.sh".

To run tcptune.sh, "sh tcptune.sh Max"


Note:  The tuning script is applicable for Gen 5 Isilon models, e.g. x410, s210, etc. and the newer Gen 6 models (F800, H600, H500, etc.) that require OneFS OS 8.1.0.x version releases.


The tcptune script is also applicable for NFS deployments with Kafka, Spark, or kdb+ with Isilon.
