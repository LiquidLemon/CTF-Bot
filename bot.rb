require 'cinch'
require_relative 'plugins/ctf'
require_relative 'plugins/quit'
require_relative 'plugins/version'
require_relative 'util/period'
require_relative 'config'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = CONFIG[:server]
    c.channels = CONFIG[:channels]
    c.nick = CONFIG[:nick]
    c.user = 'CTF-Bot'
    c.plugins.plugins = [CTFPlugin, QuitPlugin, VersionPlugin]
    c.plugins.options[CTFPlugin] = {
      lookahead: CONFIG[:lookahead],
      mark_highschool: CONFIG[:mark_highschool],
      announce_periods: CONFIG[:announcement_periods]
    }
    c.plugins.options[QuitPlugin] = {
      authorized: CONFIG[:admins],
      message: 'Leaving...'
    }
    c.plugins.options[VersionPlugin] = { version: 'CTF-Bot v0.1. Get the source at https://github.com/LiquidLemon/CTF-Bot' }
  end
end

bot.start
