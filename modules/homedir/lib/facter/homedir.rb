Facter.add("user_homedir") do
  setcode do
    %x{echo ~/}.strip
  end
end
Facter.add("user_name") do
  setcode do
    %x{echo "$(whoami)"}.strip
  end
end
