# -*- mode: ruby -*-
# vi: set ft=ruby :

rootDirPath = File.dirname(__FILE__)
propertiesFilePath = File.join(rootDirPath, "local.properties.yml")
if !File.exist?(propertiesFilePath)
   raise "\n   File \"#{propertiesFilePath}\" is not exists.\n   Please follow instructions from \"#{rootDirPath}/Readme.md\" file."
end

settingKey = "ndk.dir.linux-vagrant"
ndkPath = File.readlines(propertiesFilePath).select { |line| line.start_with?(settingKey) }.first
if ndkPath.nil?
   raise "\n   File \"#{propertiesFilePath}\" don't have setting key \"#{settingKey}\".\n   Please follow instructions from \"#{rootDirPath}/Readme.md\" file."
end

ndkPath = File.expand_path(ndkPath.sub("#{settingKey}:", "").strip())

# See:
# - https://github.com/readdle/swift-android-toolchain/blob/master/vagrant/Vagrantfile
Vagrant.configure("2") do |config|

   # Using default unsecured Vagrant SSH key dor development.
   config.ssh.insert_key = false

   # This network will be used to access server from Host machine.
   config.vm.network 'private_network', ip: '192.168.10.200'

   config.vm.synced_folder ndkPath, '/android-ndk'

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
