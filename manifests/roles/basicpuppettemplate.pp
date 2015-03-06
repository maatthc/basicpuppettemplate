# Class
class basicpuppettemplate::roles::basicpuppettemplate  inherits
        basicpuppettemplate::roles::base{
        class { '::basicpuppettemplate::profiles::nginx': }
        class { '::basicpuppettemplate::profiles::unicorn': }
        class { '::basicpuppettemplate::profiles::ruby': }
        class { '::basicpuppettemplate::profiles::simplesinatra': }
}
