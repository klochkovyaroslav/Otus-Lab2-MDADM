# -*- mode: ruby -*-
# Describe VMs
MACHINES = {
  # VM name "RAID-MDADM"
  :"RAID-MDADM" => {
              # VM box
              :box_name => "centos/7",
              # VM CPU count
              :cpus => 2,
              # VM RAM size (Mb)
              :memory => 1024,
              # networks
              :net => [],
              # forwarded ports
              :forwarded_port => [],

              :disks => {
                :sata1 => {
                    :dfile => './sata1.vdi',
                    :size => 300,
                    :port => 1
                },
                :sata2 => {
                                :dfile => './sata2.vdi',
                                :size => 300, # Megabytes
                    :port => 2
                },
                        :sata3 => {
                                :dfile => './sata3.vdi',
                                :size => 300,
                                :port => 3
                        },
                        :sata4 => {
                                :dfile => './sata4.vdi',
                                :size => 300, # Megabytes
                                :port => 4
                        },
                :sata5 => {
                                :dfile => './sata5.vdi',
                                :size => 300, # Megabytes
                                :port => 5
                },
                :sata6 => {
                                :dfile => './sata6.vdi',
                                :size => 300, # Megabytes
                                :port => 6
                        },
                :sata7 => {
                                :dfile => './sata7.vdi',
                                :size => 300, # Megabytes
                                :port => 7
                },
                :sata8 => {
                                :dfile => './sata8.vdi',
                                :size => 300, # Megabytes
                                :port => 8
                 }
        
            }
        
                
          },
        }
        Vagrant.configure("2") do |config|

          MACHINES.each do |boxname, boxconfig|
        
              config.vm.define boxname do |box|
        
                  box.vm.box = boxconfig[:box_name]
                  box.vm.host_name = boxname.to_s
                                    
                  box.vm.provider :virtualbox do |vb|
                        vb.customize ["modifyvm", :id, "--memory", "2048"]
                          needsController = false
              boxconfig[:disks].each do |dname, dconf|
                unless File.exist?(dconf[:dfile])
                vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
                                        needsController =  true
                                  end
        
              end
                          if needsController == true
                             vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
                             boxconfig[:disks].each do |dname, dconf|
                                 vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                             end
                          end
                  end
             
          #config.vm.provision "shell", path: "script.sh"
          
              end
          end
        end