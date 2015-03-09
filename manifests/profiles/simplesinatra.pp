# == Class: Installs the Sinatra App
class rea::profiles::simplesinatra (
          $path_to_sinatra_app
        )
        {
          yumrepo { 'epel':
            baseurl  => 'http://download.fedoraproject.org/pub/epel/5/i386/',
            descr    => 'Extra Packages for Enterprise Linux 5 ',
            enabled  => 1,
            gpgcheck => 0
        }
        vcsrepo { $path_to_sinatra_app:
                  ensure   => present,
                  provider => git,
                  source   => 'https://github.com/tnh/simple-sinatra-app.git',
                  revision => 'master'
        }
}
