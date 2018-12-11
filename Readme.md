I. Prerequesites
================

**Note**: Every time you see `host$` – this means that command should be executed on **HOST** macOS computer. Every time you see `box$` – this means that command should be executed on virtual **GUEST** Linux OS.

**Note**: If you found mistake or something from written below is not working, then open issue and specify exact step which fails. I.e. `Step B.2.2`.

A. Initial setup
----------------

1. Download and install software.

    - Vagrant: https://www.vagrantup.com
    - VirtualBox: https://www.virtualbox.org

    **Note**: If you have troubles with VirtualBox installation addressed blocked Kernel Extensions, then have a look on this SE question: [VirtualBox 5.1.28 fails to install on MacOS 10.13 due to KEXT security](https://apple.stackexchange.com/questions/301303/virtualbox-5-1-28-fails-to-install-on-macos-10-13-due-to-kext-security)
    
2. Verify Vagrant installation.


    ```
    host$ vagrant --version
    ```
    
3. Clone this repository.

    ```
    host$ git clone https://github.com/vgorloff/Android-On-Swift.git
    host$ cd Android-On-Swift
    ```
    
B. Setting up Ubuntu box
------------------------

**Note**: Most of the steps similar to [Getting Started](https://www.vagrantup.com/intro/getting-started/index.html) from Vagrant website.

1. Setup Ubuntu box.

    1. Download Ubuntu box image.

        **Note**: Usually you need to download box image once.
    
        ```
        host$ vagrant box add ubuntu/bionic64
        ```
    
        **Note**: You can explore trending boxes here:

        - https://app.vagrantup.com/boxes/search
        - https://app.vagrantup.com/ubuntu/boxes/bionic64

    2. (Optionall) Verify downloaded Ubuntu image in local folder.

        ```
        host$ ls -l ~/.vagrant.d/boxes
        ```

    3. Start box and connect via SSH.

        ```
        host$ vagrant up
        host$ vagrant ssh
        ```

        **Note**: Box will be created in directory specified in VirtualBox settings. Detalis in [this post](http://www.thisprogrammingthing.com/2013/changing-the-directory-vagrant-stores-the-vms-in/).

    4. (Optionall) Verify Ubuntu version.

        ```
        box$ lsb_release -irc
        ```

    5. (Optionall) Explore synced folders:

        ```
        box$ ls -l /vagrant
        ```
        
        **Note**: You should see this `Readme.md` file inside Ubuntu Box.

    As result we have Ubuntu box running on macOS.  

2. Review Box settings.

    Since we going to compile Swift. It is a good idea to review box's Memory and CPU settings to avoid situations like below.

    ```
    /usr/bin/ld.gold: out of memory
    clang: error: linker command failed with exit code 1 (use -v to see invocation)
    ```

    ```
    LLVM ERROR: out of memory
    ```

    
    1. Shutdown box.

        ```
        host$ vagrant halt
        ```

    2. Review and update config file if needed.

        ```
        Vagrant.configure("2") do |config|
        
            ...
            
            # Increase CPU and Memory values if you have enough resources.
            config.vm.provider "virtualbox" do |vb|
                vb.memory = "5120"
                vb.cpus = "4"
            end
        end
        ```

    3. Start Box again.

        ```
        host$ vagrant up
        ```

    4. (Optionall) Save snapshot of Box.

        ```
        host$ vagrant snapshot save "01. After installing clean OS"
        ```

        **Note**: Under the hood it will save VirtualBox snapshot.

C. Setting Up Visual Studio Code
--------------------------------

We will edit Ruby files, so worth to install Visual Studio Code for macOS and Ruby plugin.

1. https://code.visualstudio.com
2. Ruby language support: https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby

D. Getting Sources
------------------

Download sources:

1. Get Swift sources.

    **Note**: Steps taken from official [Guide](https://github.com/apple/swift).

    ```
    host$ mkdir -p Sources/swift
    host$ cd Sources/swift

    host$ git clone https://github.com/apple/swift.git
    host$ ./swift/utils/update-checkout --clone
    ```


2. Get Android NDK.

    1. Download from https://developer.android.com/ndk/downloads/

        **Note**: At a time of writing this text there was release named: `android-ndk-r18b-linux-x86_64.zip`

    2. Unpack archive to folder `Sources/android-ndk-r18b`.


3. Get ICU (International Components for Unicode)

    1. Download from http://site.icu-project.org/download

        **Note**: At a time of writing this text there was release named `ICU4C 63.1` and downloadable archive with sources named `icu4c-63_1-src.tgz`.

    2. Unpack archive to folder `Sources/icu`.

    As result, file structure should be like below:

    ```
    Sources
        - android-ndk-r18b
        - icu
        - swift
    Vagrantfile
    ```


4. Verify accessibility of sources inside Box.

    ```
    host$ vagrant ssh
    
    box$ env | sort
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
    ```

E. Installing dependencies on Box
---------------------------------------

1. Install development packages.

    ```
    host$ vagrant ssh

    box$ sudo apt-get update
    box$ sudo apt-get install cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config libblocksruntime-dev libcurl4-openssl-dev systemtap-sdt-dev tzdata rsync libz3-dev
    ```

2. (Optionall) Take snapshot.

    ```
    host$ vagrant snapshot save "02. After installing dependencies."
    ```

3. Install Ruby and Rake.

    **Note**: `rake` is kind of `make` for Ruby.

    ```
    box$ sudo apt-get install ruby
    ```
    
4. Verify Ruby and Rake

    ```
    box$ ruby --version
    box$ rake --version
    ```

    
II. Usage
=========

Remaining process of compilling ICU and Swift, building and deploying sample projects automated via Rakefile.

```
box$ cd /vagrant/
box$ rake
```

**Note**: Some projects need to be executed on `host`, but some on `box`. Don't mix up execution environment.
