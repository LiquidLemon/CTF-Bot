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
    @fetcher = CTF::Fetcher.new(config[:lookahead].seconds)
    @announced_ctfs = []
  end
  
  def on_upcoming(msg)
    list_upcoming(msg.channel)
  end

  def list_upcoming(channel)
    ctfs = @fetcher.ctfs    
    unless ctfs.empty?
      channel.send("Upcoming CTF's in the next #{config[:lookahead].description}:")
      ctfs.each do |ctf|
        channel.send(ctf.format(mark_hs: config[:mark_highschool]))
        @announced_ctfs.push(ctf)
      end
    else
      channel.send("There are no upcoming CTF's in the next #{config[:lookahead].description}")
    end
  end

  def update
    @fetcher.update
  end
end
