require 'cinch'

class QuitPlugin
  include Cinch::Plugin

  match 'quit'
  def execute(m)
    if config[:authorized].include?(m.user.name)
      bot.quit(config[:message])
    end
  end
end
