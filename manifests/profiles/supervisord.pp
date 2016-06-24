class rea::profiles::supervisord {
          $path_to_sinatra_app=hiera('rea::profiles::simplesinatra::path_to_sinatra_app')
          package { 'python-pip':
            ensure  => 'installed',
            require => Yumrepo['epel'],
          }->
          exec { 'pip':
            command => 'pip install supervisor',
            path    => '/usr/local/bin/:/bin/:/usr/bin/:/sbin/',
          } ->
          file { "/etc/supervisor.d/":
            ensure => 'directory',
            owner  => 'root',
            group  => 'root',
          } ->
          file { 'supervisord.conf':
            path    => '/etc/supervisord.conf',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => file('rea/supervisord.conf'),
          } ->
          file { 'supervisord.service':
            path    => '/usr/lib/systemd/system/supervisord.service',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => file('rea/supervisord.service'),
          } ->
          file { 'supervisord-unicorn.conf':
            path    => '/etc/supervisor.d/unicorn.conf',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('rea/supervisor.erb'),
          }
}