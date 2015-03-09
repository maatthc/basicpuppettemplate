# Class
class rea::profiles::nginx {
        Package {
                allow_virtual => false,
        }

        class { '::nginx': }
        nginx::resource::vhost { 'www.puppetlabs.com':
                  www_root => '/var/www/www.puppetlabs.com',
        }
}
