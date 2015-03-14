#!/bin/bash
          if [ -f /etc/puppet/puppet.conf ]
                then
                echo "Puppet Master is already installed. Exiting..."
          else
                # Install Puppet Master
                wget -q https://apt.puppetlabs.com/puppetlabs-release-precise.deb -O puppetlabs-release-precise.deb&& \
                sudo dpkg -i puppetlabs-release-precise.deb && \
                sudo apt-get update &&\
                sudo apt-get install -yq puppetmaster-passenger git puppet-lint vim
                # Setting Autosigning for Puppet Client Certificates 
                echo "*" > /etc/puppet/autosign.conf
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
                cd /etc/puppet/modules
                git clone https://github.com/maatthc/rea.git
                if [ -f /etc/puppet/manifests/site.pp ]
                then
                        rm /etc/puppet/manifests/site.pp
                fi
                sudo ln -s /etc/puppet/modules/rea/ext/site.pp /etc/puppet/manifests/site.pp
                if [ -f /etc/puppet/hiera.yaml ]
                then
                        rm /etc/puppet/hiera.yaml
                fi
                sudo ln -s /etc/puppet/modules/rea/ext/hiera.yaml /etc/puppet/hiera.yaml
                /bin/sed -i.bak 's|\[main\]|\[main\]\n\n#ADDED by VAGRANT\n# To user the each function for Array from Hiera\nparser = future\n|' /etc/puppet/puppet.conf 
                apachectl restart

          fi
