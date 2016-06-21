# Vagrant
    https://www.vagrantup.com/
## Images
### Ubuntu : ashicorp/precise32
### CentOs7: centos/7
## Install
    vagrant login
    vagrant init ashicorp/precise32
        Download the Ubuntu 32 simple and import it
    vagrant up
        It creates a 'vagrant' user and ssh keys for it.
    vagrant ssh
        It logins to the box
    sudo apt-get install git
    exit
    Vi Vagrantfile
        All boilerplate - edit to give the VM an ip and so on.
    vagrant reload
        Reload the VM with the new configuration.
    
## TODO
    Gist ??
