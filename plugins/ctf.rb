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
  end

  def on_upcoming(msg)
    list_upcoming(msg.channel)
  end

  def list_upcoming(channel)
    msg = ""
    current_ctfs = @fetcher.current_ctfs
    unless current_ctfs.empty?
      msg << "Current CTF's:\n"
      current_ctfs.each do |ctf|
        msg << CTF.format(ctf, mark_hs: config[:mark_highschool]) + "\n"
      end
    end

    upcoming_ctfs = @fetcher.upcoming_ctfs(config[:lookahead].to_seconds)
    unless upcoming_ctfs.empty?
      msg << "Upcoming CTF's in the next #{config[:lookahead]}:\n"
      upcoming_ctfs.each do |ctf|
        msg << CTF.format(ctf, mark_hs: config[:mark_highschool]) + "\n"
      end
    end

    if msg.empty?
      msg << "There are no upcoming CTF's in the next #{config[:lookahead]}\n"
    end
    channel.send(msg)
  end

  def update
    @fetcher.update
  end
end
