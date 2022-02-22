This build will be used to spin up a VM for the use of testing Horizon. 

VM Must be built into existing RG, existing virtual network, using it's own nic. VM Must be able to ping VMs inside RG as well as connected sites.

For this use, I am not going to use a module for the VM since it is a single resource (it was used in data_ex as part of the example)
