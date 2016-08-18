require_relative 'util/period'

CONFIG = {
    ## General config
    # If `daemonize` is set to true, then the bot will run in background, detached from the shell
    daemonize: true,
    # If not set then the bot will not produce logs
    log_path: 'log.txt',
    # One of: :debug, :log, :info, :warn, :error, :fatal
    log_level: :warn,

    ## IRC config
    server: 'irc.hackthissite.org',
    channels: ['#ctf'],
    nick: 'CTF-Bot',

    ## Used for the `!quit` command
    admins: ['LiquidLemon'],

    ## Specific plugin configuration
    # The next two options use a helper class `Period`
    # It takes a hash of units as it's constructor argument
    # e.g.: Period.new(weeks: 4, days: 2, hours: 1, minutes: 0, seconds: 0)
    # Null (or zero) values can be omitted

    # Specifies how distant in future the events can be
    lookahead: Period.new(weeks: 4),

    # Specifies at what time before an event a notice should be made
    announcement_periods: [
        Period.new(weeks: 2),
        Period.new(weeks: 1),
        Period.new(days: 1),
        Period.new(hours: 1)
    ],

    # Whether or not to add a helpful `[HS]` tag in front of high school level events
    mark_highschool: true
}