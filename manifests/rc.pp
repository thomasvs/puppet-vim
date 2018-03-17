#
# $name can be passed in the format ${user}:${content}
#
define vim::rc ($user='', $content='', $source=undef, $order=75)
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

  concat::fragment { "${real_user}:vimrc-${real_content}":
    target    => "${real_user}:vimrc",
    content   => $source ? {
      undef   => "${real_content}\n",
      ''      => "${real_content}\n",
      default => undef
    },
    source  => $source,
    order   => $order,
  }
}
