#node /^www\d+\.example\.com\.au$/ {
#        class { '::basicpuppettemplate': }
#}

#node 'default' {
#        class { '::basicpuppettemplate': }
#}
node default {
            hiera_include('classes','')
}
#node master {
#            hiera_include('classes','')
#}
