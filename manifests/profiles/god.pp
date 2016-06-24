class rea::profiles::god {
          $path_to_sinatra_app=hiera('rea::profiles::simplesinatra::path_to_sinatra_app')
          # Lets set the God environment
          file { '/etc/god/':
                      ensure => 'directory',
          } ->
          file { 'unicorn.god':
            path    => '/etc/god/unicorn.god',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('rea/god.erb'),
          } ->
          file { '/etc/init.d/god':
            path    => '/etc/init.d/god',
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
            content => file('rea/god.init.sh'),
          } ->
          exec { 'update-rc':
            command => 'sudo update-rc.d -f god defaults',
            path    => '/usr/local/bin/:/bin/:/usr/bin/:/sbin/',
          } ->
          exec { 'god_start':
            command => 'sudo /etc/init.d/god start',
            path    => '/usr/local/bin/:/bin/:/usr/bin/:/sbin/',
          }
}