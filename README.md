# CTF-Bot
An IRC bot that announces upcoming on-line CTF events built with the [Cinch](https://github.com/cinchrb/cinch) framework.

It also stores credentials to events' accounts.

## Installation
Make sure that you have both [Ruby](https://www.ruby-lang.org) and [Bundler](http://bundler.io/) installed. Then follow these steps:
```bash
git clone https://github.com/LiquidLemon/CTF-Bot.git
cd CTF-Bot
bundle
```

## Configuration
Example configuration is present in `config.rb` along with explanation of all the options.

## Running
Run `ruby bot.rb` in the project's root directory.

## Usage
```
!ctfs - display info about all events
!current - display info about current events
!upcoming - display info about upcoming events
!next - display info about the next event
!update - update the database (this happens automatically every hour)
!creds - modify the credentials database
!load - load the credentials database (if modified manually)
!quit - leave the server (you have to be set as an admin in the config)
!help - display this message
```