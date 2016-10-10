#
# $name can be passed in the format ${user}:${content}
#
define vim::rc ($user='', $content='')
{
  validate_string($user)

  $real_user = $user ? {
    ''      => regsubst($title, '^([^:]+):.*$', '\1'),
    default => $user
  }

  validate_string($content)

  $real_content = $content ? {
    ''       => regsubst($title, '^[^:]+:(.*)$', '\1'),
    default  => $content
  }

  concat::fragment { "${real_user}:vimrc-${name}":
    target  => "${real_user}:vimrc",
    content => "${real_content}\n",
  }
}
