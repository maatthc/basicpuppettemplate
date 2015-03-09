# Class Base - Define what is going to be applied to all hosts
# Most of the settings are in the Hiera data files
class rea::profiles::base (
          $myusers,
          $mygroups,
          $ssh_authorized_keys
        ){
        # Define which packages should be installed and 
        # which shouln't be present
        class { 'base::packages': }

        # Define user/groups to be created.
        create_resources(group, $mygroups)
        create_resources(user, $myusers)
        create_resources(ssh_authorized_key, $ssh_authorized_keys)
        
        # Firewall basics
        # iptables purge
        resources { 'firewall':
                purge   => true
        }
        Firewall {
                before  => Class['rea::base::fw_pos'],
                require => Class['rea::base::fw_pre'],
        }
        class { ['rea::base::fw_pre', 'rea::base::fw_pos']: }

        # Define SSHD configuration for all servers
        class { 'ssh': }
        firewall { '100 allow SSHD access':
                port   => [22],
                proto  => tcp,
                action => accept,
        }

        #Set the NTP Servers
        class { '::ntp': }
        firewall { '200 Allow outgoing NTP':
                chain  => 'OUTPUT',
                state  => ['NEW'],
                dport  => '123',
                proto  => 'udp',
                action => 'accept',
        }
}
