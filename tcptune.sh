# Author:  Boni Bruno, EMC
# Date: 5/5/2016
# Tune the TCP stack on Isilon.

# run sh ./tcp_tune_isilon.sh [Default, Half, or Max] as root on OneFS.

# Supply arg 1 as one of "Default", "Half" or "Max", anything else will show the current settings.
#
SET_TO_APPLY="$1"

if [ "${SET_TO_APPLY}" == "Max" ]; then
# Max (10 GbE)
  MAXSOCKBUF=16777216
  SENDBUF_MAX=16777216
  RECVBUF_MAX=16777216
  SENDBUF_INC=16384
  RECVBUF_INC=16384
  SENDSPACE=1048576
  RECVSPACE=1048576
  COALESCER_HWM=524288000
  COALESCER_LWM=262144000
elif [ "${SET_TO_APPLY}" == "Half" ]; then
  # Half of 10 GbE maximums
  MAXSOCKBUF=8388608
  SENDBUF_MAX=8388608
  RECVBUF_MAX=8388608
  SENDBUF_INC=16384
  RECVBUF_INC=16384
  SENDSPACE=524288
  RECVSPACE=524288
  COALESCER_HWM=402653184
  COALESCER_LWM=201326592
elif [ "${SET_TO_APPLY}" == "Default" ]; then
  # Defaults (1 GbE)
  MAXSOCKBUF=2097152
  SENDBUF_MAX=262144
  RECVBUF_MAX=262144
  SENDBUF_INC=8192
  RECVBUF_INC=16384
  SENDSPACE=131072
  RECVSPACE=131072
  COALESCER_HWM=47185920
  COALESCER_LWM=41943040
else
  SET_TO_APPLY=""
fi

if [ "${SET_TO_APPLY}" == "" ]; then
  echo "TCP sysctls..."
  isi_sysctl_cluster kern.ipc.maxsockbuf
  isi_sysctl_cluster net.inet.tcp.sendbuf_max
  isi_sysctl_cluster net.inet.tcp.recvbuf_max
  isi_sysctl_cluster net.inet.tcp.sendbuf_inc
  isi_sysctl_cluster net.inet.tcp.recvbuf_inc
  isi_sysctl_cluster net.inet.tcp.sendspace
  isi_sysctl_cluster net.inet.tcp.recvspace
  isi_sysctl_cluster efs.bam.coalescer.insert_hwm
  isi_sysctl_cluster efs.bam.coalescer.insert_lwm

else
  # We have something to do...

  echo "Tuning TCP stack to ${SET_TO_APPLY}"
  echo "TCP sysctls before..."
  isi_sysctl_cluster kern.ipc.maxsockbuf
  isi_sysctl_cluster net.inet.tcp.sendbuf_max
  isi_sysctl_cluster net.inet.tcp.recvbuf_max
  isi_sysctl_cluster net.inet.tcp.sendbuf_inc
  isi_sysctl_cluster net.inet.tcp.recvbuf_inc
  isi_sysctl_cluster net.inet.tcp.sendspace
  isi_sysctl_cluster net.inet.tcp.recvspace
  isi_sysctl_cluster efs.bam.coalescer.insert_hwm
  isi_sysctl_cluster efs.bam.coalescer.insert_lwm

  echo ""
  echo "Apply tuning..."
  isi_sysctl_cluster kern.ipc.maxsockbuf=${MAXSOCKBUF}
  isi_sysctl_cluster net.inet.tcp.sendbuf_max=${SENDBUF_MAX}
  isi_sysctl_cluster net.inet.tcp.recvbuf_max=${RECVBUF_MAX}
  isi_sysctl_cluster net.inet.tcp.sendbuf_inc=${SENDBUF_INC}
  isi_sysctl_cluster net.inet.tcp.recvbuf_inc=${RECVBUF_INC}
  isi_sysctl_cluster net.inet.tcp.sendspace=${SENDSPACE}
  isi_sysctl_cluster net.inet.tcp.recvspace=${RECVSPACE}
  isi_sysctl_cluster efs.bam.coalescer.insert_hwm=${COALESCER_HWM}
  isi_sysctl_cluster efs.bam.coalescer.insert_lwm=${COALESCER_LWM}

  echo ""
  echo "TCP sysctls after..."
  isi_sysctl_cluster kern.ipc.maxsockbuf
  isi_sysctl_cluster net.inet.tcp.sendbuf_max
  isi_sysctl_cluster net.inet.tcp.recvbuf_max
  isi_sysctl_cluster net.inet.tcp.sendbuf_inc
  isi_sysctl_cluster net.inet.tcp.recvbuf_inc
  isi_sysctl_cluster net.inet.tcp.sendspace
  isi_sysctl_cluster net.inet.tcp.recvspace
  isi_sysctl_cluster efs.bam.coalescer.insert_hwm
  isi_sysctl_cluster efs.bam.coalescer.insert_lwm

fi
echo ""

