# Class that manages the Ruby Gems
class rea::profiles::ruby (
                $gems 
        ){
        $gems = ['bundler', 'rack', 'sinatra', 'god', 'unicorn']
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
