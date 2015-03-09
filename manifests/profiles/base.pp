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
        # Define SSHD configuration for all servers
        class { 'ssh': }
        # Define user/groups to be created.
        create_resources(group, $mygroups)
        create_resources(user, $myusers)
        create_resources(ssh_authorized_key, $ssh_authorized_keys)
}
