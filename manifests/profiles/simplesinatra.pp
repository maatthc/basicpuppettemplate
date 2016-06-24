# == Class: Installs the Sinatra App
class rea::profiles::simplesinatra (
          $path_to_sinatra_app
        )
        {
         file { $path_to_sinatra_app:
            ensure => 'directory',
            owner  => 'root',
            group  => 'root',
            mode    => '0755'
          } ->
          vcsrepo { $path_to_sinatra_app:
                  ensure   => present,
                  provider => git,
                  source   => 'https://github.com/tnh/simple-sinatra-app.git',
                  revision => 'master'
        }
}
