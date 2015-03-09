#node /^www\d+\.example\.com\.au$/ {
#        class { '::rea': }
#}

#node 'default' {
#        class { '::rea': }
#}
node default {
            hiera_include('classes','')
}
#node master {
#            hiera_include('classes','')
#}
