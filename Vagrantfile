# -*- mode: ruby -*-
# vi: set ft=ruby :

# See:
# - https://github.com/readdle/swift-android-toolchain/blob/master/vagrant/Vagrantfile
Vagrant.configure("2") do |config|

   config.vm.box = "ubuntu/bionic64"
   config.disksize.size = '25GB'
   config.vm.provision :shell, inline: "echo 'source /vagrant/Scripts/Shell/environment.sh' > /etc/profile.d/sa-environment.sh", :run => 'always'

   config.vm.provider "virtualbox" do |vb|
      vb.memory = "5120" # Setting value less that `5120` can cause linker to fail.
      vb.cpus = `sysctl -n hw.physicalcpu`.to_i # use all available
   end
end
