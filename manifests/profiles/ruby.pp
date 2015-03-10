# Class that manages the Ruby Gems
class rea::profiles::ruby (
                $gems
        ){
        package { $gems:
                  ensure        => 'installed',
                  allow_virtual => false,
                  provider      => 'gem',
        }
        # Ensure the SO packages are present
        class { '::ruby':
                  rubygems_update => false,
        }
}
