require 'cinch'
require_relative 'plugins/ctf'
require_relative 'plugins/quit'
require_relative 'plugins/version'
require_relative 'util/period'

authorized = ['LiquidLemon']

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.hackthissite.org'
    c.channels = ['#liquidbot']
    c.nick = 'CTF-Bot'
    c.user = 'CTF-Bot'
    c.plugins.plugins = [CTFPlugin, QuitPlugin, VersionPlugin]
    c.plugins.options[CTFPlugin] = { 
      lookahead: Period.new(weeks: 4),
      mark_highschool: true,
      announce_periods: [
          Period.new(weeks: 2),
          Period.new(weeks: 1),
          Period.new(days: 1),
          Period.new(hours: 1)
      ]
    }
    c.plugins.options[QuitPlugin] = {
      authorized: authorized,
      message: 'Leaving...'
    }
    c.plugins.options[VersionPlugin] = { version: 'CTF-Bot v0.1' }
  end
end

bot.start
