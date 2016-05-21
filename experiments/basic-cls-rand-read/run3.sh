#!/bin/bash

reset=soft
data_dev=sdc
noop_dev=sdc

name=librados_jewel_ssd_large
runtime=1800
pg_nums="128"
stripe_widths="128"
queue_depths="32"
entry_sizes="4096"
pool=zlog
rest=120
read_runtime=1800
reads=yes

# workloads
wl_11="map_11 bytestream_11"
wl_n1="map_n1 bytestream_n1_write"
workloads="$wl_11 $wl_n1"

# i/o interfaces
map_n1_if="vanilla"
bytestream_n1_write_if="vanilla"
bytestream_n1_append_if="vanilla"

. $ZLOG_ROOT/docker/physical-design/runner.sh
run_pd
