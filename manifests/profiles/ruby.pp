class basicpuppettemplate::profiles::ruby { 
        # Ensure the SO packages are present
         Package {
                     allow_virtual => false, 
        }
        class { '::ruby':
                  version         => '1.8.7',
                  gems_version    => '1.8.24',
                  rubygems_update => false,
        }
        # Ensure the required gems are present
        $gems = ['bundler', 'sinatra', 'rack']
        package { $gems:
                  ensure        => 'installed',
                  allow_virtual => false,
                  provider      => 'gem',
        }
}
