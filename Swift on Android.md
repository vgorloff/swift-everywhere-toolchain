Prerequesites:

Downloads

1. Vagrant: https://www.vagrantup.com
2. VirtualBox: https://www.virtualbox.org

If you have troubles with VirtualBox installation, then have a look on this SE Question: [VirtualBox 5.1.28 fails to install on MacOS 10.13 due to KEXT security](https://apple.stackexchange.com/questions/301303/virtualbox-5-1-28-fails-to-install-on-macos-10-13-due-to-kext-security)

Verifying the Installation:

`vagrant --version`

Most of the steps similar to [Getting Started](https://www.vagrantup.com/intro/getting-started/index.html) from Vagrant website.

Project Setup:

```
mkdir swift-on-android
cd swift-on-android

vagrant init ubuntu/bionic64
```

Creating Ubuntu instance:

1. Installing a Box:

Explore boxes:

- https://app.vagrantup.com/boxes/search
- https://app.vagrantup.com/ubuntu/boxes/bionic64

`vagrant box add ubuntu/bionic64`

This will download Ubuntu image to local folder:

`ls -l ~/.vagrant.d/boxes`

* Up And SSH

```
vagrant up
vagrant ssh
```

Box will be created in directory specified in VirtualBox settings. Detalis in [this post](http://www.thisprogrammingthing.com/2013/changing-the-directory-vagrant-stores-the-vms-in/).

Verify Ubuntu version:

```
lsb_release -irc
```

Explore synced folders:

```
ls -l /vagrant
```

Now we have Ubuntu on macOS .)

Since we going to compile Swift there is a good idea to increase Box memory.

```
vagrant halt
```

Update config file:

```
Vagrant.configure("2") do |config|
   config.vm.box = "ubuntu/bionic64"

   config.vm.provider "virtualbox" do |vb|
      vb.memory = "2560" # Customize the amount of memory on the VM
   end
end
```

Start Box again.

```
vagrant up
```


-------------


We will edit Ruby files, so worth to install Visual Studio Code for macOS.

1. https://code.visualstudio.com
2. Ruby language support: https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby

