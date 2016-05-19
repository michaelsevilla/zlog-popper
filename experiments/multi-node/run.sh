#!/bin/bash

set -ex

#for i in 1 2 3 4 5 6 7 8 9 10; do
#for i in 2; do
#  ANSIBLE_LOG_PATH="logs/radosbench-${i}.log" \
#  ansible-playbook --forks 50 --skip-tags "with_pkg" \
#  -i inventory/cluster-${i}node -e inventory_name=cluster-${i}node \
#  ceph.yml workloads/radosbench.yml
#done

ANSIBLE_LOG_PATH="logs/radosbench-${i}.log" \
ansible-playbook --forks 50 --skip-tags "with_pkg" \
ceph.yml workloads/bench-ng.yml
