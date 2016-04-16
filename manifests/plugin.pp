# = Define vim::plugin
#
# This define adds a vim plugin for pathogen using git
#
# The title can be parsed as ${user}:${plugin} if they are left
# unspecified.
#
# The title needs to be unique for multiple users anyway, so
# that's why parsing is there.
#
# [* plugin *]
#   name of the plugin; used for the directory under .vim/bundle
#
# [* source *]
#   the git repository url to clone the plugin from
#
define vim::plugin ($source, $user='', $plugin='', $ensure=present) {
  validate_string($user)

  $real_user = $user ? {
    ''      => regsubst($title, '^([^:]+):.*$', '\1'),
    default => $user
  }

  validate_string($plugin)

  $real_plugin = $plugin ? {
    ''       => regsubst($title, '^[^:]+:(.*)$', '\1'),
    default  => $plugin
  }

  $home_dir = user_home($real_user)

  # See https://tickets.puppetlabs.com/browse/MODULES-731
  # ensure => absent runs every time and says
  # Notice: /Stage[main]/Profile::Root::Vim/Amantes::Vim[root]/Vim::Plugin[root:vim-session]/Vcsrepo[/root/.vim/bundle/vim-session]/ensure: created
  # wrap it in an if instead
  if $ensure != 'absent' {
    vcsrepo { "${home_dir}/.vim/bundle/${real_plugin}":
      ensure   => $ensure,
      provider => git,
      user     => $real_user,
      source   => $source,
    }
  } else {
    file { "${home_dir}/.vim/bundle/${real_plugin}":
      ensure => absent
    }
  }
}
