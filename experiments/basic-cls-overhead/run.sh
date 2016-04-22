#!/bin/bash

reset=soft
data_dev=sdc

name=basic_cls_overhead
runtime=120
pg_nums="128"
stripe_widths="128"
queue_depths="16"
entry_sizes="1024"
pool=zlog
rest=60

# workloads
wl_n1="bytestream_n1_append"
workloads="$wl_n1"

# i/o interfaces
#
# vanilla: librados
# cls_no_index_wronly: cls + append
# cls_check_epoch: cls + omap-epoch-check + append
# cls_check_epoch_hdr: cls + hdr-epoch-check + append
#
bytestream_n1_append_if="vanilla cls_no_index_wronly cls_check_epoch cls_check_epoch_hdr cls_full cls_full_hdr_idx"

. $ZLOG_ROOT/docker/physical-design/runner.sh
run_pd
