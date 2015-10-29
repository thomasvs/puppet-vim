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
define vim::plugin ($home_dir, $source, $user='', $plugin='') {
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

  vcsrepo { "${home_dir}/.vim/bundle/${plugin}":
    ensure   => present,
    provider => git,
    user     => $user,
    source   => $source,
  }
}
