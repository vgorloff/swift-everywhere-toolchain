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

Optionally save snapshot

```
vagrant snapshot save "01. After installing clean OS"
```

Under the hood it will save VirtualBox snapshot.

-------------

We will edit Ruby files, so worth to install Visual Studio Code for macOS.

1. https://code.visualstudio.com
2. Ruby language support: https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby

Download sources:

1. Swift:

Steps taken from [Guide](https://github.com/apple/swift)

```
mkdir -p Sources/swift
cd Sources/swift

git clone https://github.com/apple/swift.git
./swift/utils/update-checkout --clone
```


2. Android NDK

- https://developer.android.com/ndk/downloads/

At a time of writing this text there was release named: `android-ndk-r18b-linux-x86_64.zip`

Unpack archive to folder `Sources/android-ndk-r18b`


3. ICU - International Components for Unicode

- http://site.icu-project.org/download

At a time of writing this text there was release named: `ICU4C 63.1`. Download sources `icu4c-63_1-src.tgz`

Unpack archive to folder `Sources/icu`

So, structure should be like:

```
Sources
   - android-ndk-r18b
   - icu
   - swift
Vagrantfile
```

4. Provisioning Box

Environment variables:

Create file `Scripts/bootstrap.sh`

```
## Sources
export SA_SOURCES_ROOT=/vagrant/Sources

export SA_SOURCES_ANDK=$SA_SOURCES_ROOT/android-ndk-r18b
export SA_SOURCES_ICU=$SA_SOURCES_ROOT/icu
export SA_SOURCES_SWIFT=$SA_SOURCES_ROOT/swift

## Build
export SA_BUILD_ROOT=/vagrant/Build

export SA_BUILD_ROOT_ANDK=$SA_BUILD_ROOT/android-ndk
export SA_BUILD_ROOT_ICU=$SA_BUILD_ROOT/icu
export SA_BUILD_ROOT_SWIFT=$SA_BUILD_ROOT/swift

## Path
export PATH=$PATH:$SA_SOURCES_ANDK

```

Update `Vagrantfile` in order to enable Provisioning.

```
Vagrant.configure("2") do |config|
   config.vm.box = "ubuntu/bionic64"
   config.vm.provision :shell, inline: "echo 'source /vagrant/Scripts/bootstrap.sh' > /etc/profile.d/sa-environment.sh", :run => 'always'

   config.vm.provider "virtualbox" do |vb|
      vb.memory = "2560" # Customize the amount of memory on the VM
   end
end
```

Verify setup:

```
vagrant ssh
env | sort
```

Should output:
```
...
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/vagrant/Sources/android-ndk-r18b
PWD=/home/vagrant
SA_BUILD_ROOT_ANDK=/vagrant/Build/android-ndk
SA_BUILD_ROOT_ICU=/vagrant/Build/icu
SA_BUILD_ROOT_SWIFT=/vagrant/Build/swift
SA_BUILD_ROOT=/vagrant/Build
SA_SOURCES_ROOT_ANDK=/vagrant/Sources/android-ndk-r18b
SA_SOURCES_ROOT_ICU=/vagrant/Sources/icu
SA_SOURCES_ROOT=/vagrant/Sources
SA_SOURCES_ROOT_SWIFT=/vagrant/Sources/swift
...
````

5. Installing needed pakaged on Box

```
vagrant ssh
sudo apt-get update

# Swift dependencies:
sudo apt-get install cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config libblocksruntime-dev libcurl4-openssl-dev systemtap-sdt-dev tzdata rsync libz3-dev

sudo apt-get install git libcurl4 ???
```

Not a bad idea to take snapshot:

```
vagrant snapshot save "02. After installing dependencies."
```

6. Installing Ruby and Rake

Rake is kind of Make for Ruby .)

```
sudo apt-get install ruby

# Verify
ruby --version
rake --version
```

7. Using Rakefile

```
cd /vagrant/
rake
```
