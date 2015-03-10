# Class
class rea::roles::rea { 
        class { '::rea::profiles::base': } ->        
        class { '::rea::profiles::ruby': } ->
        class { '::rea::profiles::simplesinatra': } ->
        class { '::rea::profiles::unicorn': } ->
        class { '::rea::profiles::nginx': }
}
