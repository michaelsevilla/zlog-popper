multi-node
----------

Runs ZLog on a cluster using `ceph-ansible` to deploy and `docker-cephdev` to
install dependencies. To run the experiment:

```bash
# tell me about your cluster
vim hosts
   
# tell me about how you want ceph configured
vim group_vars/*
    
# fire away!
./run.sh
```
