## mesosnodes-ansible

Contains Ansible Playbooks and Roles for creating mesosnodes.

### Introduction

It is possible to create nodes
* locally, on some development system
* or on a production system,
depending on which inventory file is chosen.

*Note: Currently only CoreOS as a host OS is supported*

### Configuration

In order to create nodes correctly, some configuration values might need a change. Variables which should be the same for every platform are saved in *group_vars/mesosnodes*. However, variables which most likely need to be changed, depending on the chosen target are set in the *inventory files*.

Variables that might need to be changed:
* `ansible_ssh_host`/`vm_ip` set this to the same ip value, is related to the ip range of your virtualisation platform (libvirt or vm internal networking)

* `vm_mac` the MAC address of the virtual machine/mesosnode

* `mesos_install_mode` mode/role of the node; can be set to *master-slave*, *master*, *slave*. Keep in mind for HA it is wise to have at least three *master(-slave)* nodes present. For every *master(-slave)* node a corresponding *[zookeeper_hosts]* entry must exist (same `inventory_hostname` as *[mesosnode]*)

* `zoo_id` must be a unique number for each host where zookeeper is installed

* `discovery_url` set this to a new value when creating a brand new cluster (use returned value of `curl -w "\n" https://discovery.etcd.io/new`) or set this to the value the existing cluster uses (find this out by connecting to an existing node and check the *cloud-init* file)

* `vm_host` the host system for the virtual machine Mesos runs on. Can be different for each *[mesosnode]* host. For example *mesosnode01* can run von *grzcislvkvm01* and *mesosnode02* can run on *grzcislvkvm02*, and so on.

### Create Nodes

Basically, to create nodes just run `ansible-playbook -i <inventory-file> create-nodes.yml`.
This is true for creating nodes on remote development systems and the production system.

As mentioned in "Configuration" just make sure that `discovery_url` in the corresponding inventory file is updated (execute `curl -w "\n" https://discovery.etcd.io/new` and copy/paste the value).

Or, when there are already existing nodes, use the same `discovery_url` for the new nodes to be added (so connect to a node and consult the cloud-init file or etcd to get the URL).

#### Pitfalls with local creation

When creating nodes (especially with *libvirt*) locally there are some things to be considered.

* Some commands are executed with `su` (the su value is set to true). Either make sure it is possible for your local user to execute `su` without password or add the flag `--ask-su-pass` to the ansible command.

* Furthermore, on some Linux OSses (like Ubuntu) the root user has no password and therefore also add the line `--su-user=` with the value set to your login user.

* Connection type `local` cannot be used, because it has no support for `su`.

* When having ssh connection issues with locally commands, try `-c paramiko` (or configure your local sshd so that it can handle multiple connections properly).

* When using `-c paramiko` and you encounter an error message like `{'msg': 'FAILED: Incompatible ssh peer (no acceptable kex algorithm)', 'failed': True}` try upgrading your paramiko installation  (`sudo pip install --upgrade paramiko`)
