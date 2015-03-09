# Class fw_pre - 
# Define Firewall rules that runs before Module specific rules
class rea::base::fw_pre {
  Firewall {
    require => undef,
  }

  # Allow traffic from Trusted Networks
  $trusted_networks = hiera_array('firewall::trusted_networks')
  $trusted_networks.each |$network| {
    firewall { "000 allow all traffic from ${network}":
      proto  => 'all',
      source => $network,
      action => 'accept',
    }
  }
  # basic in/out
  firewall { '000 accept all icmp':
    chain  => 'INPUT',
    proto  => 'icmp',
    action => 'accept',
  }

  firewall { '001 accept all to lo interface':
    chain   => 'INPUT',
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }

  firewall { '003 accept related established rules':
    chain  => 'INPUT',
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '004 accept related established rules':
    chain  => 'OUTPUT',
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  # extra
  firewall { '200 allow outgoing icmp type 8 (ping)':
    chain  => 'OUTPUT',
    proto  => 'icmp',
    icmp   => 'echo-request',
    action => 'accept',
  }
  
  firewall { '200 allow outgoing dns lookups':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '53',
    proto  => 'udp',
    action => 'accept',
  }
  #For packages install
  firewall { '200 allow outgoing https':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '443',
    proto  => 'tcp',
    action => 'accept',
  }
  firewall { '200 allow outgoing http':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '80',
    proto  => 'tcp',
    action => 'accept',
  }
  firewall { '200 Allow outgoing Puppets':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '8140',
    proto  => 'tcp',
    action => 'accept',
  }
}
