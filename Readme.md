Setup and Build
===============

**Note**: Every time you see `host$` – this means that command should be executed on **HOST** macOS computer. Every time you see `box$` – this means that command should be executed on virtual **GUEST** Linux OS.

1. Download and install software.

    - Vagrant: https://www.vagrantup.com
    - VirtualBox: https://www.virtualbox.org

    **Note**: If you have troubles with VirtualBox installation addressed blocked Kernel Extensions, then have a look on this SE question: [VirtualBox 5.1.28 fails to install on MacOS 10.13 due to KEXT security](https://apple.stackexchange.com/questions/301303/virtualbox-5-1-28-fails-to-install-on-macos-10-13-due-to-kext-security)

2. Verify Vagrant installation.

    ```bash
    host$ vagrant --version
    ```

3. Download Ubuntu image.

    **Note**: Usually you need to download box image once.

    ```bash
    host$ vagrant box add ubuntu/bionic64
    ```

    **Note**: You can explore trending boxes here:

    - https://app.vagrantup.com/boxes/search
    - https://app.vagrantup.com/ubuntu/boxes/bionic64

4. Clone this repository.

    ```bash
    host$ git clone https://github.com/vgorloff/Android-On-Swift.git
    host$ cd Android-On-Swift
    ```

5. (Optionall) Verify downloaded Ubuntu image in local folder.

    ```bash
    host$ ls -l ~/.vagrant.d/boxes
    ```

6. Start box and connect via SSH.

    ```bash
    host$ vagrant up
    # (Optionall) Take snapshot. Under the hood it will save VirtualBox snapshot.

    host$ vagrant snapshot save "Clean System"

    host$ vagrant ssh

    # (Optionall) Explore synced folders. You should see this `Readme.md` file inside Ubuntu Box.
    box$ ls -l /vagrant
    ```

    **Note**: Box will be created in directory specified in VirtualBox settings. Detalis in [this post](http://www.thisprogrammingthing.com/2013/changing-the-directory-vagrant-stores-the-vms-in/).

7. (Optional) Setting Up Visual Studio Code

    If you going to edit Ruby files, then it worth to install Visual Studio Code for macOS and Ruby plugin.

    - Visual Studio Code: https://code.visualstudio.com
    - Ruby language support: https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby

8. Start a build.

   **Note**: Process of compilling Swift Toolchain, building and deploying sample projects automated via Rakefile.

   ```bash
   box$ cd /vagrant/
   box$ rake | more
   ```
