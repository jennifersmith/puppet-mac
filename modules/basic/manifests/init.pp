class basic {               
 
 Package { provider => "homebrew"}

 define github ($path = "${::user_homedir}dev/", $repo_name = $name, $github_user = jennifersmith, $ensure = present){
    vcsrepo { "${path}${name}/":
      ensure => $ensure,
      provider => git,
      source => "git@github.com:${github_user}/${repo_name}.git"
    } 
  }

  github {"bin": path => $::user_homedir , repo_name=>misc, ensure=>latest}

  github {"private-settings": path =>"${::user_homedir}/bin/", require=>Github["bin"], ensure=>latest}
  github {".emacs.d": path =>$::user_homedir, repo_name=>"otfrom-org-emacs", ensure=>latest}  

  github {["janus", "puppet-mac", "myblog", "flocky", "janus-generators"]:}
  

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

  dotfile {["bash_profile", "bashrc" , "gemrc", "gitconfig", "gvimrc", "util", "vimrc", "aspell.en.pws"]:}
  dotdir {["lein", "bash"]:}
  class {'weirdassvim':}
  class {'rvm::system': homedir=>$::user_homedir }  

 
  # treating homebrew as an exec... who package manages the package managers?
  exec {
        '/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"':
        creates => '/usr/local/bin/brew'}
 	
  class{"leiningen": require => Dotdir["lein"]}


  package{ 'aspell' : provider=>homebrew, install_options =>{lang=>'en'}}
  package {'llvm' : provider=>homebrew, install_options=>{flags=>'--universal'}}
  package {'postgresql' : provider=>homebrew, install_options=>{flags=>'--no-tcl'}}

package { ["ack",
"gist",
"git",
"glib",
"gnupg",
"python",
"readline",
"s3cmd",
"markdown",
"wget"] :}

}

