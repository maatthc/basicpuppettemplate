# Class that manages the Ruby Gems
class rea::profiles::ruby {
        # Ensure the required gems are present
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
