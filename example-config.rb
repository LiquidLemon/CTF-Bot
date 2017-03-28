require_relative 'util/period'
require 'ostruct'

CONFIG = OpenStruct.new
## General config
# If `daemonize` is set to true, then the bot will run in background, detached from the shell
CONFIG.daemonize = true
# If not set then the bot will not produce logs
CONFIG.log_path = 'log.txt'
# One of: :debug, :log, :info, :warn, :error, :fatal
CONFIG.log_level = :warn
# File used to store credentials
CONFIG.credentials_path = 'credentials.json'

## IRC config
CONFIG.server = 'irc.hackthissite.org'
CONFIG.channels = ['#ctf']
CONFIG.nick = 'CTF-Bot'

# Prefix used for the bot's commands
# Defaults to '!'
CONFIG.prefix = '!'

# How many events should be listed in a channel
CONFIG.event_limit = 3

## Used for the `!quit` command
CONFIG.admins = ['LiquidLemon']

## Specific plugin configuration
# The next two options use a helper class `Period`
# It takes a hash of units as it's constructor argument
# e.g.: Period.new(weeks: 4, days: 2, hours: 1, minutes: 0, seconds: 0)
# Null (or zero) values can be omitted

# Specifies how distant in future the events can be
CONFIG.lookahead = Period.new(weeks: 4)

# Specifies at what time before an event a notice should be made
CONFIG.announcement_periods = [
  Period.new(weeks: 2),
  Period.new(weeks: 1),
  Period.new(days: 1),
  Period.new(hours: 1)
]

# Whether or not to add a helpful `[HS]` tag in front of high school level events
CONFIG.mark_highschool = true
