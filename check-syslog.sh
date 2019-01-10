#!/bin/bash
# This script is meant for Isilon clusters running OneFS 8.x
# usage: sh check-syslog.sh
# run from root on Isilon OneFS.


echo ''
echo "Creating base directory for gather."
echo ''


if [ -d "/ifs/data/Isilon_Support/auditsyslog/$(date +%m%d%Y)" ]; then
        DIR0="/ifs/data/Isilon_Support/auditsyslog/$(date +%m%d%Y_%H%M)"

else
        DIR0="/ifs/data/Isilon_Support/auditsyslog/$(date +%m%d%Y)"

fi



# Create base Directorys

        mkdir -p $DIR0
        echo $DIR0 > /ifs/data/Isilon_Support/auditsyslog/DIR
        DIR0=$(cat /ifs/data/Isilon_Support/auditsyslog/DIR)
        isi_for_array mkdir $DIR0/'`hostname`'


echo ''
echo 'Gathering audit settings for all the zones '
echo ''



        isi audit settings global view > $DIR0/audit_settings_global_view
        isi zone zones list -v > $DIR0/zone_list
        for i in `isi zone zones list |grep /|awk '{print $1}'` ;do echo ++++++zone $i ; isi audit settings view --zone=$i ;done > $DIR0/audit_settings_view_zone
        isi_for_array -s procstat -f '`pgrep syslogd`' |grep audit_ > $DIR0/procstat
        isi_for_array netstat -rn |grep def > $DIR0/default_rout

echo ''
echo 'Grab log files from each node'
echo ''


        isi_for_array cp '/var/log/messages' $DIR0/'`hostname`'
        isi_for_array cp '/var/log/audit_config.log*' $DIR0/'`hostname`'
        isi_for_array cp '/var/log/audit_protocol.log*' $DIR0/'`hostname`'
        isi_for_array cp '/etc/mcp/templates/syslog.conf' $DIR0/'`hostname`'/templates.syslog.conf
        isi_for_array cp '/etc/syslog.conf' $DIR0/'`hostname`'/etc.syslog.conf

echo ''
echo 'Grabing audit data for todays date from all the nodes'
echo ''



        isi_for_array 'isi_audit_viewer -t protocol -s `date '+%Y-%m-%d'` > /var/crash/Audit.data.log'
        isi_for_array mv '/var/crash/Audit.data.log' $DIR0/'`hostname`'
        x=$(ls /ifs/.ifsvar/audit/consumer | grep -v CEE); y="$DIR0/audit_progress";date >> ${y}; isi_for_array -s isi_audit_progress -t protocol "$x" >> ${y}


echo
echo starting ktraces

        mkdir -p $DIR0/ktrace
        isi_for_array -X 'ktrace -p `pgrep syslogd` -f $(cat /ifs/data/Isilon_Support/auditsyslog/DIR)/ktrace/`hostname`_syslogd.ktrace'; isi_for_array -X 'ktrace -p `pgrep isi_audit_sys` -f $(cat /ifs/data/Isilon_Support/auditsyslog/DIR)/ktrace/`hostname`_audit_syslog.ktrace'

echo
echo 'ktrace being gathered in' $DIR0


echo ''
echo 'Starting pcaps....'

        mkdir -p $DIR0/pcap
        isi_for_array -X 'for iface in $(tcpdump -D | sed s/\[0-9\]\.// | egrep -v "lo0|ib0|ib1|igb0|igb1") ; do tcpdump -s 320 -i $iface -w $(cat /ifs/data/Isilon_Support/auditsyslog/DIR)/pcap/$(uname -n).$(date +%m%d%Y_%H%M%S).$iface._audit_count.pcap port 514 2>>$(cat /ifs/data/Isilon_Support/auditsyslog/DIR)/pcap/capture_stderr.out 2>>$(cat /ifs/data/Isilon_Support/auditsyslog/DIR)/pcap/capture_stderr.out & ; done' &


echo ''
        echo Pcaps started.... ;
        sleep 1


isi_for_array -s logger "this is just a test"

sleep 60

echo ''
echo 'Stopping pcaps and ktraces'

        isi_for_array -s 'killall -SIGINT tcpdump'
        isi_for_array 'ktrace -C'

echo ''
echo Pcaps and ktraces stopped.....
echo ''
