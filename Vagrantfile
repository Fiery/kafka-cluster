# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# -*- mode: ruby -*-
# vi: set ft=ruby :

$num_brokers = 4
$num_keepers = 5
$broker_name_prefix = 'broker'
$keeper_name_prefix = 'keeper'
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 #config.vm.box = "precise64"

 # The url from where the 'config.vm.box' box will be fetched if it
 # doesn't already exist on the user's system.
 #config.vm.box_url = "http://files.vagrantup.com/precise64.box"

 # Keeping consistent with coreos/Vagrantfile
 keeper_list = []
  (1..$num_keepers).each do |i| 
    keeper_list.push "172.17.8.#{i+100}"
  end

  (1..$num_keepers).each do |i| 
    config.vm.define vm_name = "%s-%02d" % [$keeper_name_prefix, i] do |config|
      config.vm.provider :docker do |node|
        #node.customize ["modifyvm", :id, "--memory", "512"]
        node.build_dir="./zookeeper-docker"
        #node.image = 'wurstmeister/zookeeper'
        node.ports = ['2181:2181','2888:2888','3888:3888']
        node.name="#{vm_name}-docker"
        #node.has_ssh = true
        node.vagrant_vagrantfile = "./coreos/Vagrantfile"
        node.vagrant_machine = "core-%02d" % [i]
        node.env={ "ZK_ID"=>i, 
                  "ZK_NODES"=> keeper_list.join(' ')}
        node.volumes = ['/var/run/docker.sock:/var/run/docker.sock']#,'/vagrant:/vagrant']

        ###Equivalent docker command          
        ## "docker" "run" 
        ## "--name" "#{vm_name}-docker" 
        ## "-d" 
        ## "-e" "ZK_ID=1" 
        ## "-e" "ZK_NODES=172.17.8.101 172.17.8.102 172.17.8.103 172.17.8.104 172.17.8.105" 
        ## "-p" "2181:2181"
        ## "-v" "/var/lib/docker/docker_1439936944_80047:/vagrant" "5270108aea69"

        #node.volumes = ['/var/run/docker.sock:/var/run/docker.sock']
        #node.volumes = ['/vagrant:/vagrant']
      end

      ###
      #  All other host configuration ignored when using external vagrantfile as host
      #
      # zookeeper.vm.network :private_network, ip: "192.168.10.100"
      # zookeeper.vm.provision "shell", path: "vagrant/zk.sh"
      # zookeeper.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
      ###
    end
  end

  #brokers = []
  (1..$num_brokers).each do |i| 
    #config.vm.provider :virtualbox do |host|
    #  host.customize ["modifyvm", :id, "--memory", "512"]
    #end
    config.vm.define vm_name = "%s-%02d" % [$broker_name_prefix, i] do |config|
      config.vm.provider :docker do |node|
        node.build_dir = "./kafka-docker"
        node.name = "#{vm_name}-docker"
        #node.has_ssh = true
        node.vagrant_vagrantfile = "./coreos/Vagrantfile"
        node.vagrant_machine = "core-%02d" % [$num_keepers+i]
        #node.link("zookeeper-docker:zk")
        node.env ={ "KAFKA_ADVERTISED_HOST_NAME"=>"172.17.8.#{$num_keepers+i+100}" % [101+i],
                    "KAFKA_HEAP_OPTS"=>"-Xmx2G -Xms1G",
                    "KAFKA_ZOOKEEPER_CONNECT"=>"172.17.8.101:2181",
                    "KAFKA_BROKER_ID"=>"#{i}"
                  }
        node.ports = ['9092:9092']
        node.volumes = ['/var/run/docker.sock:/var/run/docker.sock']#,'/vagrant:/vagrant']
      end

      ###
      #  All other host configuration ignored when using external vagrantfile as host
      #
      # config.vm.network :private_network, ip: "192.168.10.%d" % [101+i]
      # config.vm.synced_folder "./", "/vagrant", type: "rsync", rsync__exclude: ".git/"
      # #brokerOne.vm.synced_folder "."
      # #brokerOne.vm.provision "shell", path: "./start-kafka.sh", :args => "1"
      ###
    end
  end
end
