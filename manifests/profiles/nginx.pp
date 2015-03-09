# Class
class rea::profiles::nginx {
        $path_to_sinatra_app=hiera("rea::profiles::simplesinatra::path_to_sinatra_app")
        $sinatra_server_name=hiera("rea::profiles::simplesinatra::sinatra_server_name")
        file { 'nginx.conf':
                path    => '/etc/nginx/nginx.conf',
                owner   => 'nginx',
                group   => 'nginx',
                mode    => '0644',
                content => template('rea/nginx.erb'),
                notify  => Service[nginx]
        }
        service { 'nginx':
                ensure => running,
                enable => true,
        }
        firewall { '100 allow HTTP access':
                port   => [80],
                proto  => tcp,
                action => accept,
        }
}
