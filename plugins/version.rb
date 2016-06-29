require 'cinch'

class VersionPlugin
  include Cinch::Plugin
  
  ctcp :version
  def ctcp_version(m)
    m.ctcp_reply config[:version]
  end

end
