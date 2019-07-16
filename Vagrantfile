# -*- mode: ruby -*-
# vi: set ft=ruby :

# See:
# - https://github.com/readdle/swift-android-toolchain/blob/master/vagrant/Vagrantfile
Vagrant.configure("2") do |config|

   # Using default unsecured Vagrant SSH key dor development.
   config.ssh.insert_key = false

   # This network will be used to access server from Host machine.
   config.vm.network 'private_network', ip: '192.168.10.200'

   config.vm.box = "ubuntu/bionic64"
   config.vm.provision :shell, path: "Scripts/Shell/bootstrap.sh"
   config.vm.provision :shell, inline: "echo 'source /vagrant/Scripts/Shell/environment.sh' > /etc/profile.d/sa-environment.sh", :run => 'always'
   config.vm.provision :shell, path: "Scripts/Shell/brew.sh", privileged: false
   config.vm.provision :shell, path: "Scripts/Shell/verify.sh"

   config.vm.provider "virtualbox" do |vb|
      vb.memory = "5120" # Setting value less that `5120` can cause linker to fail.
      vb.cpus = `sysctl -n hw.physicalcpu`.to_i # use all available
   end
end
