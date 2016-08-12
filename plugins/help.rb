require 'cinch'

class HelpPlugin
  include Cinch::Plugin

  match 'help'
  def execute(m)
    @bot.config.plugins.options.values.each do |plugin|
      unless plugin[:help].nil?
        m.user.send(plugin[:help])
      end
    end
    m.user.send('!help - display this message')
  end
end