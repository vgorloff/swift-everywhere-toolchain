# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
   config.vm.box = "ubuntu/bionic64"
   config.vm.provision :shell, inline: "echo 'source /vagrant/Scripts/bootstrap.sh' > /etc/profile.d/sa-environment.sh", :run => 'always'

   config.vm.provider "virtualbox" do |vb|
      vb.memory = "2560" # Customize the amount of memory on the VM
   end
end
