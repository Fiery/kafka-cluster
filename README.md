Containerized Kafka Cluster on VMs
==================================

Repo of configuration codes for a set of kafka brokers running with a zookeeper cluster.

Deployed by Vagrant and Docker, CoreOS as host vm. Works on any VirtualBox/Vagrant compatible OS (Windows/Unix/BSD/MacOS)


##Prerequisites
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/)
- [CoreOS](https://github.com/coreos/coreos-vagrant) for Vagrant
- Docker comes with CoreOS so don't worry about Docker if you are using CoreOS as host.

##Usage
Before start the cluster, make sure you config enough hosts/containers needed

- Start shell/cmd/Terminal on your server, then go ```vagrant up keeper-## ```

- Repeat above step up to the configured number of zookeeper

- Similarily, ```vagrant up broker-## ``` up to what has been configured in [Vagrantfile](https://github.com/Fiery/kafka-cluster/Vagrantfile)

##Configuration
Configurable items are meant to be kept in main [Vagrantfile](https://github.com/Fiery/kafka-cluster/Vagrantfile), Inject necessary ENVs into your container so Docker can automate the provisioning.

##Initiative
Minimize deployment effort and standardize machine specification when available environment is not container firendly i.e. deploying on servers running Windows.

Also, not running Docker container in single host considered potentially being able to easily scale out into multiple physical machine environment.