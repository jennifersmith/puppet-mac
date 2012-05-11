class basic {
 
 define github ($path = "${::user_homedir}dev/", $repo_name = $name, $github_user = jennifersmith){
    vcsrepo { "${path}${name}/":
      ensure => latest,
      provider => git,
      source => "git@github.com:${github_user}/${repo_name}.git"
    } 
  }

  define dropbox-git  ($path = "${::user_homedir}dev/", $repo_path="${::user_homedir}Dropbox/git/${name}.git" ){
    vcsrepo { "${path}${name}/":
      ensure => latest,
      provider => git,
      source => "$repo_path"
    } 
  }
  github {"bin": path => $::user_homedir , repo_name=>misc}

  github {"bin/private-settings": path =>"${::user_homedir}/bin", repo_name=>"private-settings", require=>Github["bin"]}
  
  #dev ones use the defaults apart from rapidftr 
  github {["wire_tap", "4clojure_answers", "myblog", "plasma", "photo-management","flickr-clojure", "flickr-facebook-clj"]:}
  
  github {"rapidftr/dev": repo_name => RapidFTR}
  github {"rapidftr/merge": repo_name => RapidFTR, github_user => jorgej}

  github {"mingle-stats" :}

  define dotfile(){
   file { "${::user_homedir}.${name}":
       ensure => link,
           target => "${::user_homedir}bin/dotfiles/${name}",
    }
  }

  define dotdir(){
     file { "${::user_homedir}/.${name}":
       ensure => link,
           target => "${::user_homedir}bin/dotfiles/${name}/",
    }
  }

  class weirdassvim {
   file { "${::user_homedir}/.vim":
       ensure => link,
           target => "${::user_homedir}bin/dotfiles/vim/vim",
    }
  }

  dotfile {["bash_profile", "bashrc" , "gemrc", "gitconfig", "gvimrc", "util", "vimrc"]:}
  dotdir {["lein", "bash", "emacs.d"]:}
  class {'weirdassvim':}
  class {'rvm::system': homedir=>$::user_homedir }  
 
  # treating homebrew as an exec... who package manages the package managers?
  exec {
        '/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"':
        creates => '/usr/local/bin/brew'}
 	
  package {'emacs':
    provider=>homebrew,
    ensure=>HEAD,
    install_options=> { flags => "--cocoa --use-git-head --HEAD"} }

  class{"leiningen": require => Dotdir["lein"]}


package {'ack': provider=>homebrew}
  package {'llvm' : provider=>homebrew, install_options=>{flags=>'--universal'}}

  package { 'gist' : provider=>homebrew}
  exec {
    '/bin/sh lein plugin install swank-clojure 1.3.3':
      unless => '/bin/sh lein | grep jack',
      require => Class['leiningen']
    }
}

