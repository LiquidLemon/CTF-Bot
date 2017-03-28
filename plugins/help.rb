require 'cinch'
require_relative '../config'

class HelpPlugin
  include Cinch::Plugin

  match 'help'
  def execute(m)
    @bot.config.plugins.options.values.each do |plugin|
      unless plugin[:help].nil?
        m.user.notice(plugin[:help])
      end
    end
  end
end
