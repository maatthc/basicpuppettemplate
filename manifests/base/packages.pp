# Class
class rea::base::packages {
        $packages_install = hiera_array('packages_install', '')
        $packages_purge = hiera_array('packages_purge', '')
        yumrepo { 'epel':
            baseurl  => 'http://download.fedoraproject.org/pub/epel/7/$basearch',
            descr    => 'Extra Packages for Enterprise Linux 7 ',
            enabled  => 1,
            gpgcheck => 0
        } ->
        package { $packages_install:
                ensure        => latest,
                allow_virtual => false,
        } ->
        package { $packages_purge:
                ensure        => purged,
                allow_virtual => false
        }
}
