# Class to setup the Unicorn App Server and the God Service Managers
class rea::profiles::unicorn {
      $path_to_sinatra_app=hiera('rea::profiles::simplesinatra::path_to_sinatra_app')
      if $osfamily == "RedHat" {
          # Lets use SupervisorD
          include rea::profiles::supervisord
      }  else {
          # God is the process that controls the Unicorn process.
          include rea::profiles::god
      }
      file { "${path_to_sinatra_app}/tmp/":
        ensure => 'directory',
        owner  => 'unicorn',
        group  => 'unicorn',
      } ->
      file { "${path_to_sinatra_app}/logs/":
        ensure => 'directory',
        owner  => 'unicorn',
        group  => 'unicorn',
      } ->
      file { 'unicorn.conf':
        path    => "${path_to_sinatra_app}/unicorn.conf",
        owner   => 'unicorn',
        group   => 'unicorn',
        mode    => '0644',
        content => template('rea/unicorn.erb'),
      } ->
      if $osfamily == "RedHat" {
          service { 'supervisord':
            ensure => 'running',
            enable => 'true',
          }
      }  else {
          service { 'god':
            ensure  => running,
          }
      }
}
