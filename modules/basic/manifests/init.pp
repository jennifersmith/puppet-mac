# Bin folder from git
class basic {
  notice("using user ${username}")
      vcsrepo { "/Users/${username}/bin/":
        ensure => present,
        provider => git,
        source => "git@github.com:jennifersmith/misc.git"
 }
}
