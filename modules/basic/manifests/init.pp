# Bin folder from git
class basic {
  notice("using user ${username}")
  $root_folder = "/Users/${username}"
      vcsrepo { "${root_folder}/bin/":
        ensure => present,
        provider => git,
        source => "git@github.com:jennifersmith/misc.git"
  } 
  # and it's aliases
  file { "${root_folder}/.bashrc":
    ensure => link,
    target => "${root_folder}/bin/dotfiles/bashrc",
  }

}
