Facter.add("user_homedir") do
  setcode do
    %x{echo ~/}.strip
  end
end
