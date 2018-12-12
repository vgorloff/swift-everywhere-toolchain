# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
   config.vm.box = "ubuntu/bionic64"
   config.vm.provision :shell, inline: "echo 'source /vagrant/Scripts/Shell/environment.sh' > /etc/profile.d/sa-environment.sh", :run => 'always'

   config.vm.provider "virtualbox" do |vb|
      vb.memory = "5120" # Setting value less that `5120` can cause linker to fail.
      vb.cpus = "4" # Setting value less that `4` can cause sloooooow compile time.
   end
end
