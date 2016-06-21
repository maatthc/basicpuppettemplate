#!/bin/bash
          if [ -f /etc/puppetlabs/puppet/puppet.conf ]
          then
                echo "Puppet Agent is already installed. Aborting..."
          else
                # Install Puppet Master
                sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm && \
                sudo yum -y install puppet-agent && \

                # Configure /etc/hosts file
                if cat /etc/hosts |grep master 2> /dev/null
                        then
                        echo "/etc/hosts already set. Ignoring.."
                else
                        echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
                        echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
                        echo "10.0.1.50    master.example.com  master" | sudo tee --append /etc/hosts 2> /dev/null && \
                        echo "10.0.1.51    agent.example.com  agent" | sudo tee --append /etc/hosts 2> /dev/null
                fi
                /bin/sed -i.bak 's|\[main\]|\[main\]\n\n#ADDED by VAGRANT\n# \n server=master \n|' /etc/puppetlabs/puppet/puppet.conf
                /bin/sed -i.bak 's|START=no|START=yes|' /etc/default/puppet 
                service puppet restart

          fi
