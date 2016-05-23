#!/bin/bash

reset=soft
data_dev=nvme0n1
noop_dev="nvme0n1"
osd_create="--bluestore"

name=librados_read_data_nvme_bluestore
#runtime=1800
runtime=500
pg_nums="128"
stripe_widths="128"
queue_depths="32"
entry_sizes="1024"
pool=zlog
rest=120
#read_runtime=1800
read_runtime=500
reads=yes

# workloads
wl_11="map_11 bytestream_11"
wl_n1="map_n1 bytestream_n1_write"
#workloads="$wl_11 $wl_n1"
workloads="$wl_n1"

# i/o interfaces
map_n1_if="vanilla"
bytestream_n1_write_if="vanilla"
bytestream_n1_append_if="vanilla"

. $ZLOG_ROOT/docker/physical-design/runner.sh
run_pd
