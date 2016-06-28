#!/bin/bash
# Default values 
distro="centos"
role="agent"
http_proxy=""

if [ -n "$1" ]; then
        distro=`echo $1 | tr 'A-Z' 'a-z'`
fi
if [ -n "$2" ]; then
        role=`echo $2 | tr 'A-Z' 'a-z'`
fi

# Checking for host proxy
# Having a local proxy service running locally speed up installing packages on the Vagrant images.
# For Mac OS: http://squidman.net/squidman/
exit_code=http_proxy='http://10.0.1.1:8888' curl www.google.com -o -  >/dev/null 2>&1
if [ $? -eq 0 ]; then
    http_proxy="http://10.0.1.1:8888"
fi

echo "Setting up : Role: $role - Distro: $distro - Proxy: $http_proxy"


###### Start of Functions

function install_packages {
    if [ -n "$3" ]; then
        http_proxy=$3
    fi
    case $1 in
       centos) 
           # Install Repo
           sudo http_proxy=$http_proxy rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm 
           case $2 in
                agent)
                    # Install Agent
                    sudo http_proxy=$http_proxy yum -y install puppet-agent
                    ;;
                master)
                   # Install Master
                   sudo http_proxy=$http_proxy yum -y install puppetserver git vim
                   ;;
           esac
           ;;
       ubuntu)
           # Install Repo
           sudo http_proxy=$http_proxy wget -q https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb -O puppetlabs-release-xenial.deb&& \
           sudo http_proxy=$http_proxy dpkg -i puppetlabs-release-xenial.deb && \
           sudo http_proxy=$http_proxy apt-get update
           case $2 in
                   agent)
                        # Install Agent
                        sudo http_proxy=$http_proxy apt-get build-dep -yq puppet
                        sudo http_proxy=$http_proxy apt-get install -yq puppet
                        ;;
                   master)
                       # Install Master
                       sudo http_proxy=$http_proxy apt-get build-dep -yq puppetmaster-passenger
                       sudo http_proxy=$http_proxy apt-get install -yq puppetmaster-passenger git puppet-lint vim
                       ;;
           esac
           ;;
    esac
                  
}

function setup_puppet {
    # Configure /etc/hosts file
    if cat /etc/hosts |grep puppet 2> /dev/null
    then
        echo "/etc/hosts already set. Ignoring.."
    else
        echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
        echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
        echo "10.0.1.50    puppet.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
        echo "10.0.1.51    webserver-centos.example.com  webserver-centos" | sudo tee --append /etc/hosts 2> /dev/null && \
        echo "10.0.1.52    webserver-ubuntu.example.com  ubuntu-centos" | sudo tee --append /etc/hosts 2> /dev/null
    fi
    case $1 in
        centos)
           PUPPET_BASE=/etc/puppetlabs/puppet/
           PUPPET_CODE=/etc/puppetlabs/code/environments/production
           PUPPET_MANIFEST=$PUPPET_CODE/manifests/
           PUPPET_HIERADATA=$PUPPET_CODE/hieradata/
           PUPPET_CONF=/etc/sysconfig/puppetserver
           ;;

        ubuntu)
           PUPPET_BASE=/etc/puppet
           PUPPET_CODE=$PUPPET_BASE
           PUPPET_MANIFEST=$PUPPET_BASE/manifests/
           PUPPET_HIERADATA=$PUPPET_CODE/hieradata/
           PUPPET_CONF=/etc/default/puppetserver
           ;;
    esac
    case $2 in
        master)
            # Setting Autosigning for Puppet Client Certificates
            echo "*" > $PUPPET_BASE/autosign.conf
            cd $PUPPET_CODE/modules
            sudo curl -L https://github.com/maatthc/rea/tarball/master -o maat-rea.tgz
            if [ ! -f /usr/bin/puppet ]; then ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet ; fi
            puppet module install maat-rea.tgz
            if [ -f $PUPPET_MANIFEST/site.pp ]; then
                    sudo rm $PUPPET_MANIFEST/site.pp
            fi
            sudo ln -sf $PUPPET_CODE/modules/rea/ext/site.pp $PUPPET_MANIFEST/site.pp
            if [ -f $PUPPET_BASE/hiera.yaml ]; then
                    sudo rm $PUPPET_BASE/hiera.yaml
            fi
            sudo ln -sf $PUPPET_CODE/modules/rea/ext/hiera.yaml $PUPPET_BASE/hiera.yaml
            if [ -d $PUPPET_HIERADATA ]; then cp $PUPPET_CODE/modules/rea/hieradata/* $PUPPET_HIERADATA; fi
            if [ -s $PUPPET_CONF ]; then sudo /bin/sed -i.bak 's|-Xms2g -Xmx2g|-Xms512m -Xmx512m|' $PUPPET_CONF; fi
            if [ $1 = "ubuntu" ] ; then sudo rm -r  /var/lib/puppet/ssl/ && sudo puppet cert -g master-ubuntu --dns_alt_names=master,puppet,puppet-master,puppet.mgmt && \
                echo -e ":yaml:\n        :datadir: '/etc/puppet/modules/rea/hieradata/'" >> $PUPPET_BASE/hiera.yaml ; fi
            ;;
        
        agent)
            ;;
    esac
}

function restart_puppet {
    case $1 in
        centos)
           case $2 in
               agent) 
                    sudo systemctl enable puppet 
                    sudo systemctl restart puppet 
                    ;;
               master) 
                    sudo systemctl enable puppetserver
                    sudo systemctl restart puppetserver
                    ;;
           esac
           ;;
        ubuntu)
           case $2 in
               agent) 
                    sudo puppet agent --enable 
                    sudo service puppet restart
                    ;;
               master) sudo apachectl restart
                    ;;
           esac
           ;;
    esac
}
###### End of Functions
install_packages $distro $role $http_proxy

setup_puppet $distro $role

restart_puppet $distro $role

