class vim::install {

  case $::osfamily {
    'RedHat': { $vim_package = 'vim-enhanced' }
    default: { $vim_package = 'vim' }
  }

  package { 'vim':
    ensure => installed,
    name   => $vim_package,
  }
}
