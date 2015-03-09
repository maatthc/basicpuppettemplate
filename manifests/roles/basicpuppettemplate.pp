# Class
class rea::roles::rea  inherits
        rea::roles::base{
        class { '::rea::profiles::nginx': }
        class { '::rea::profiles::unicorn': }
        class { '::rea::profiles::ruby': }
        class { '::rea::profiles::simplesinatra': }
}
