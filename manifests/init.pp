#
# Define vim
#
# Deploy basic vim configuration for a user.
#
# Sets up pathogen for plugins, and some default vim options.
#
define vim() {

  $user = $title

  $home_dir = user_home($user)

  include wget

  include vim::install

  validate_string($user)
  validate_absolute_path($home_dir)

  file { [
    "${home_dir}/.vim",
    "${home_dir}/.vim/autoload",
    "${home_dir}/.vim/bundle",
    ] :
    ensure => 'directory',
    owner  => $user,
  }

  file { "${home_dir}/.vimrc.local" :
    owner   => $user,
    replace => false,
    content => "\"Add here your custom options for vim, puppet will not override them\n",
  }

  wget::fetch { "DownloadPathogen-${user}":
    source      => 'https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim',
    destination => "${home_dir}/.vim/autoload/pathogen.vim",
    verbose     => true
  }

  file { "${home_dir}/.vim/autoload/pathogen.vim":
    owner => $user
  }

  concat { "${user}:vimrc":
    path  => "${home_dir}/.vimrc",
    owner => $user,
    group => 'root',
    mode  => '0664',
  }

  Concat::Fragment {
    target  => "${user}:vimrc",
  }

  concat::fragment { "${user}:rc-header":
# FIXME: can we remove this target line?
    target  => "${user}:vimrc",
    source  => 'puppet:///modules/vim/vimrc/header',
    order   => '05',
  }

  vim::rc { "${user}:vimrc-pathogen":
    source  => 'puppet:///modules/vim/vimrc/pathogen',
    order   => '10',
  }

  vim::rc { "${user}:vimrc-local":
    source  => 'puppet:///modules/vim/vimrc/local',
  }

  vim::rc { "${user}:syntax on": }
  vim::rc { "${user}:filetype plugin indent on": }
  vim::rc { "${user}:set modeline": }

  Package['vim']
  -> File[
    "${home_dir}/.vim",
    "${home_dir}/.vim/autoload",
    "${home_dir}/.vim/bundle"
  ]
  -> Wget::Fetch["DownloadPathogen-${user}"]
  -> File["${home_dir}/.vim/autoload/pathogen.vim"]
  -> Concat["${user}:vimrc"]

}
