require 'cinch'
require_relative 'ctf/fetcher'
require_relative '../util/period'
require 'pry'

class CTFPlugin
  include Cinch::Plugin

  listen_to :connect, :method => :on_connect
  match 'ctfs', :method => :on_ctfs
  match 'update', :method => :update
  match 'next', :method => :on_next

  # Update every hour
  timer 60*60, :method => :update

  def on_connect(*)
    @fetcher = CTF::Fetcher.new
    @fetcher.offset = config[:lookahead].to_seconds
    @scheduled_announcements = {}

    self.update
  end

  def on_ctfs(msg)
    list_ctfs(msg.channel)
  end

  def on_next(msg)
    announce_next(msg.channel)
  end

  def list_ctfs(channel)
    msg = ""
    current_ctfs = @fetcher.current_ctfs
    unless current_ctfs.empty?
      msg << "Current CTF's:\n"
      current_ctfs.each do |ctf|
        msg << CTF.format(ctf, mark_hs: config[:mark_highschool]) + "\n"
      end
    end

    upcoming_ctfs = @fetcher.upcoming_ctfs
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

  def update(*)
    @fetcher.update
    @fetcher.upcoming_ctfs.each do |ctf|
      unless @scheduled_announcements.has_key?(ctf)
        @scheduled_announcements[ctf] = []
        config[:announce_periods].each do |period|
          announcement_time = ctf['start'].to_time - period.to_i
          timeout = announcement_time - Time.now
          unless timeout < 0
            @scheduled_announcements[ctf].push(announcement_time)
            Timer(timeout, shots: 1) do
              announce_ctf(ctf, period.to_s)
            end
          end
        end
      end
    end
  end

  def announce_ctf(ctf, time_string, channel = nil)
    msg = "[!] #{time_string} left until " << CTF.format(ctf, add_dates: false)
    if channel.nil?
      @bot.channels.each do |chan|
        chan.send(msg)
      end
    else
      channel.send(msg)
    end
  end

  def announce_next(channel)
    ctf = @scheduled_announcements.min_by { |key, arr| arr.min }.first
    time_left = ctf['start'].to_time - Time.now
    time_string = Period.from_seconds(time_left.to_i).to_s(:minutes)
    announce_ctf(ctf, time_string, channel)
  end
end
