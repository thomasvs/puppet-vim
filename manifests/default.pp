#
# Sets defaults for vimrc that not everyone might want
#
define vim::default() {

  $user = $title

  vim::rc { "${user}:highlight comment ctermfg=darkgray": }
  vim::rc { "${user}::set bg=dark": }
}
