I. Prerequesites
================

**Note**: Every time you see `host$` – this means that command should be executed on **HOST** macOS computer. Every time you see `box$` – this means that command should be executed on virtual **GUEST** Linux OS.

**Note**: If you found mistake or something from written below is not working, then open issue and specify exact step which fails. I.e. `Step B.1.ii`.

A. Initial setup
----------------

1. Download and install software.

    - Vagrant: https://www.vagrantup.com
    - VirtualBox: https://www.virtualbox.org

    **Note**: If you have troubles with VirtualBox installation addressed blocked Kernel Extensions, then have a look on this SE question: [VirtualBox 5.1.28 fails to install on MacOS 10.13 due to KEXT security](https://apple.stackexchange.com/questions/301303/virtualbox-5-1-28-fails-to-install-on-macos-10-13-due-to-kext-security)

2. Verify Vagrant installation.

    ```bash
    host$ vagrant --version
    ```

3. Clone this repository.

    ```bash
    host$ git clone https://github.com/vgorloff/Android-On-Swift.git
    host$ cd Android-On-Swift
    ```

B. Setting up Ubuntu box
------------------------

**Note**: Most of the steps similar to [Getting Started](https://www.vagrantup.com/intro/getting-started/index.html) from Vagrant website.

1. Setup Ubuntu box.

    1. Download Ubuntu box image.

        **Note**: Usually you need to download box image once.

        ```bash
        host$ vagrant box add ubuntu/bionic64
        ```

        **Note**: You can explore trending boxes here:

        - https://app.vagrantup.com/boxes/search
        - https://app.vagrantup.com/ubuntu/boxes/bionic64

    2. (Optionall) Verify downloaded Ubuntu image in local folder.

        ```bash
        host$ ls -l ~/.vagrant.d/boxes
        ```

    3. Start box and connect via SSH.

        ```bash
        host$ vagrant up
        host$ vagrant ssh
        ```

        **Note**: Box will be created in directory specified in VirtualBox settings. Detalis in [this post](http://www.thisprogrammingthing.com/2013/changing-the-directory-vagrant-stores-the-vms-in/).

    4. (Optionall) Verify Ubuntu version and Explore synced folders.

        ```bash
        box$ lsb_release -irc
        box$ ls -l /vagrant
        ```

        **Note**: You should see this `Readme.md` file inside Ubuntu Box.

    As result we have Ubuntu box running on macOS.


C. (Optional) Setting Up Visual Studio Code
-------------------------------------------

If you going to edit Ruby files, then it worth to install Visual Studio Code for macOS and Ruby plugin.

1. Visual Studio Code: https://code.visualstudio.com
2. Ruby language support: https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby

E. Installing dependencies on Box
---------------------------------------

1. Install development packages and Verify Ruby and Rake version.

    ```bash
    host$ vagrant ssh

    box$ bash /vagrant/Scripts/Shell/bootstrap.sh
    ```

2. (Optionall) Take snapshot.

    ```bash
    host$ vagrant snapshot save "Clean System"
    ```

    **Note**: Under the hood it will save VirtualBox snapshot.

II. Usage
=========

Remaining process of compilling Swift Toolchain, building and deploying sample projects automated via Rakefile.

```bash
box$ cd /vagrant/
box$ rake
```

**Note**: Some Rake targets need to be executed on `host`, but some on `box`. Don't mix up execution environment.
