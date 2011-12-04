# Bin folder from git
class basic {
  notice("using user ${username}")
  $root_folder = "/Users/${username}"
      vcsrepo { "${basic::root_folder}/bin/":
        ensure => present,
        provider => git,
        source => "git@github.com:jennifersmith/misc.git"
  } 
  
  define dotfile(){
   file { "${basic::root_folder}/.${name}":
       ensure => link,
           target => "${basic::root_folder}/bin/dotfiles/${name}",
    }
  }

  define dotdir(){
     file { "${basic::root_folder}/.${name}":
       ensure => link,
           target => "${basic::root_folder}/bin/dotfiles/${name}/",
    }
  }

  class weirdassvim {
   file { "${basic::root_folder}/.vim":
       ensure => link,
           target => "${basic::root_folder}/bin/dotfiles/vim/vim",
    }
  }

  dotfile {["bash_profile", "bashrc" , "gemrc", "gitconfig", "gvimrc", "util", "vimrc"]:}
  dotdir{"bash":}
  class {'weirdassvim':}
  class {'rvm::system': user=>$username}  
  	
  package {'emacs': 
                    provider=>homebrew,
										ensure=>HEAD,
                    install_options=> { flags => "--cocoa --use-git-head --HEAD"} 
          }

}
