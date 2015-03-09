# Class
class rea::base::packages {
        $packages_install = hiera_array('packages_install', '')
        $packages_purge = hiera_array('packages_purge', '')
        package { $packages_install:
                ensure        => latest,
                allow_virtual => false
        }
        package { $packages_purge:
                ensure        => purged,
                allow_virtual => false
        }
}
