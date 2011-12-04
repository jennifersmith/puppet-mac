# Bin folder from git
class basic {
  notice("using user ${username}")
  $root_folder = "/Users/${username}"
      vcsrepo { "${root_folder}/bin/":
        ensure => present,
        provider => git,
        source => "git@github.com:jennifersmith/misc.git"
  } 
  
  define dotfile(){
   file { "${root_folder}/.${name}":
       ensure => link,
           target => "${root_folder}/bin/dotfiles/${name}",
    }
  }

  define dotdir(){
     file { "${root_folder}/.${name}":
       ensure => link,
           target => "${root_folder}/bin/dotfiles/${name}/",
    }
  }

  class weirdassvim {
   file { "${root_folder}/.vim":
       ensure => link,
           target => "${root_folder}/bin/dotfiles/vim/vim",
    }
  }

  dotfile {["bash_profile", "bashrc" , "gemrc", "gitconfig", "gvimrc", "util", "vimrc"]:}
  dotdir{"bash":}
  class {'weirdassvim':}
}
