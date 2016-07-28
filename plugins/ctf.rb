require 'cinch'
require_relative 'ctf/fetcher'

class CTFPlugin
  include Cinch::Plugin

  listen_to :connect, :method => :on_connect
  match 'upcoming', :method => :on_upcoming
  match 'update', :method => :update

  # Update every hour
  timer 60*60, :method => :update

  def on_connect(*)
    debug "Running :on_connect"
    @fetcher = CTF::Fetcher.new
    @announced_ctfs = []
  end

  def on_upcoming(msg)
    list_upcoming(msg.channel)
  end

  def list_upcoming(channel)
    msg = ""
    ctfs = @fetcher.upcoming_ctfs(config[:lookahead].to_seconds)
    unless ctfs.empty?
      msg << "Upcoming CTF's in the next #{config[:lookahead]}:\n"
      ctfs.each do |ctf|
        msg << CTF.format(ctf, mark_hs: config[:mark_highschool]) + "\n"
        @announced_ctfs.push(ctf)
      end
    else
      msg << "There are no upcoming CTF's in the next #{config[:lookahead]}\n"
    end
    channel.send(msg)
  end

  def update
    @fetcher.update
  end
end
