# == Class: Installs the Sinatra App
class rea::profiles::simplesinatra (
          $path_to_sinatra_app
        )
        {
          vcsrepo { $path_to_sinatra_app:
                  ensure   => present,
                  provider => git,
                  source   => 'https://github.com/tnh/simple-sinatra-app.git',
                  revision => 'master'
        }
}
