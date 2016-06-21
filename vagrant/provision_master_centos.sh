#!/bin/bash
          if [ -f /etc/puppetlabs/puppet/puppet.conf ]
                then
                echo "Puppet Master is already installed. Aborting..."
          else
                # Install Puppet Master
                sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm && \
                sudo yum -y install puppetserver git vim
                # Setting Autosigning for Puppet Client Certificates 
                sudo echo "*" > /etc/puppetlabs/puppet/autosign.conf
                # Configure /etc/hosts file
                if cat /etc/hosts |grep agent 2> /dev/null
                        then
                        echo "/etc/hosts already set. Ignoring.."
                else
                        echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
                        echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
                        echo "10.0.1.50    master.example.com  master" | sudo tee --append /etc/hosts 2> /dev/null && \
                        echo "10.0.1.51    agent.example.com  agent" | sudo tee --append /etc/hosts 2> /dev/null
                fi
                cd /etc/puppetlabs/code/modules
                sudo git clone https://github.com/maatthc/rea.git
                if [ -f /etc/puppetlabs/code/environments/production/manifests/site.pp ]
                then
                        sudo rm /etc/puppetlabs/code/environments/production/manifests/site.pp
                fi
                sudo ln -s /etc/puppetlabs/code/modules/rea/ext/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp
                if [ -f /etc/puppetlabs/puppet/hiera.yaml ]
                then
                        sudo rm /etc/puppetlabs/puppet/hiera.yaml
                fi
                sudo ln -s /etc/puppetlabs/code/modules/rea/ext/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml
                sudo /bin/sed -i.bak 's|\[main\]|\[main\]\n\n#ADDED by VAGRANT\n# To user the each function for Array from Hiera\nparser = future\n|' /etc/puppetlabs/puppet/puppet.conf
                sudo systemctl restart puppetserver

          fi
