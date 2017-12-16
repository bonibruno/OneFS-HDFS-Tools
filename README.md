# OneFS-HDFS-Tools
OneFS HDFS Scripts:

nndnstat.sh - shows namenode and datanode connections on Isilon.
tcptune.sh - tunning script to improve HDFS performance.  Use either Max, Half or Default and test.

To run nndnstat.sh, just login as root on Isilon, copy the script and make it executable, then run "sh nndnstat.sh".

To run tcptune.sh, "sh tcptune.sh Max"


Note:  The tuning script is applicable for Gen 5 Isilon models only, e.g. x410, s210, etc.  Newer Gen 6 models (F800, H600, H500, etc.) require OneFS OS 8.1.0.x version releases, the newer OneFS OS versions do not need tcptune. 
