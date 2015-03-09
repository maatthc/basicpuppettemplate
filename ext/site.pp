#node /^www\d+\.example\.com\.au$/ {
#        class { '::rea': }
#}

#node 'default' {
#        class { '::rea': }
#}
node default {
            hiera_include('classes','')
}
if versioncmp($::puppetversion,'3.6.1') >= 0 {
          $allow_virtual_packages = hiera('allow_virtual_packages',false)
            Package {
                allow_virtual => $allow_virtual_packages,
            }
}
#node master {
#            hiera_include('classes','')
#}
