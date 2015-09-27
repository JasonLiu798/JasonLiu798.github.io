
#config
http://xuclv.blog.51cto.com/5503169/1239250
##share foler
config.vm.synced_folder "python", "/opt/pythonprj"

##memory
config.vm.provider "virtualbox" do |v|
  v.memory = 2048
end

##network
###1brige 
v2
Vagrant.configure("2") do |config|
  config.vm.network :public_network
end
v1
Vagrant::Config.run do |config|
  config.vm.network :bridged
end

VBoxManage list bridgedifs | grep ^Name  
    Name:            eth0
###set eth
Vagrant::Config.run do |config|
  config.vm.network :bridged, :bridge => "eth0"
end

###2port
v2
Vagrant.configure("2") do |config|
  config.vm.network :forwarded_port, guest: 80, host: 8080
end
v1
Vagrant::Config.run do |config|
  # Forward guest port 80 to host port 8080
  config.vm.forward_port 80, 8080
end

###3 hostonly
v2
Vagrant.configure("2") do |config|
  config.vm.network :private_network, ip: "192.168.50.4"
end
v1
Vagrant::Config.run do |config|
  config.vm.network :hostonly, "192.168.50.4"
end



#command
vagrant init ubuntu/trusty64
vagrant up
vagrant ssh
vagrant reload

###shutdown
vagrant halt 
###delete
vagrant destroy



#Q&A
##Q Connection Timeout
##A
http://junnan.org/blog/2014-06-27-fix-vagrant-error-connection-timeout.html
