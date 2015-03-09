# Class
class rea::profiles::ruby {
        # Ensure the required gems are present
        $gems = ['bundler', 'sinatra', 'rack']
        package { $gems:
                  ensure        => 'installed',
                  allow_virtual => false,
                  provider      => 'gem',
        }
        # Ensure the SO packages are present
        Package {
                allow_virtual => false,
        }
        class { '::ruby':
                  rubygems_update => false,
        }
}
