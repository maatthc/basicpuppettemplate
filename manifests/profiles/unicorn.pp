# Class
class rea::profiles::unicorn {
      $path_to_sinatra_app=hiera("rea::profiles::simplesinatra::path_to_sinatra_app")
      file { 'unicorn.conf':
        path    => "$path_to_sinatra_app/unicorn.conf",
        owner   => 'unicorn',
        group   => 'unicorn',
        mode    => '0644',
        content => template('rea/unicorn.erb'),
        notify  => Service[god]
      }
      file { "$path_to_sinatra_app/tmp/":
        ensure => "directory",
        owner   => 'unicorn',
        group   => 'unicorn',
      }
      file { "$path_to_sinatra_app/logs/":
        ensure => "directory",
        owner   => 'unicorn',
        group   => 'unicorn',
      }
      # God is the process that controls the Unicorn process.
      # Lets set the God environment
      file { "/etc/god/":
                  ensure => "directory",
      }
      file { 'unicorn.god':
        path    => "/etc/god/unicorn.god",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('rea/god.erb'),
        notify  => Service[god]
      }
      exec { "set_inittab":
        command => "echo -e god:2345:respawn:/usr/bin/god --log-level error -D -c \'/etc/god/*.god\' >> /etc/inittab",
        path    => "/usr/local/bin/:/bin/:/usr/bin/:/sbin/",
      }
      exec { "telinit":
        command => "telinit q",
        path    => "/usr/local/bin/:/bin/:/usr/bin/:/sbin/",
      }
      service { "god":
        ensure  => running,
        start   => "god start",
        stop    => "god stop",
        pattern => "/usr/bin/god",
      }
}
