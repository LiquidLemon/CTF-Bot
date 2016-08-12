require 'cinch'
require_relative 'plugins/ctf'
require_relative 'plugins/quit'
require_relative 'plugins/version'
require_relative 'plugins/help'
require_relative 'util/period'
require_relative 'config'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = CONFIG[:server]
    c.channels = CONFIG[:channels]
    c.nick = CONFIG[:nick]
    c.user = 'CTF-Bot'
    c.plugins.plugins = [CTFPlugin, QuitPlugin, VersionPlugin, HelpPlugin]
    c.plugins.options[CTFPlugin] = {
      lookahead: CONFIG[:lookahead],
      mark_highschool: CONFIG[:mark_highschool],
      announce_periods: CONFIG[:announcement_periods],
      help: "!ctfs - display info about upcoming events\n" +
          "!next - display info about the next event\n" +
          "!update - update the database (this happens automatically every hour)\n"
    }
    c.plugins.options[QuitPlugin] = {
      authorized: CONFIG[:admins],
      message: 'Leaving...',
      help: '!quit - leave the server (you have to be set as an admin in the config)'
    }
    c.plugins.options[VersionPlugin] = { version: 'CTF-Bot v0.1. Get the source at https://github.com/LiquidLemon/CTF-Bot' }
  end
end

bot.start
