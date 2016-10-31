require 'cinch'
require 'json'
require_relative 'ctf/fetcher'
require_relative '../util/period'

class CTFPlugin
  include Cinch::Plugin

  listen_to :connect, :method => :on_connect
  match 'ctfs', :method => :on_ctfs
  match 'current', :method => :on_current
  match 'upcoming', :method => :on_upcoming
  match 'update', :method => :update
  match 'next', :method => :on_next
  match(/creds/, :method => :on_creds)
  match 'load', :method => :load_credentials

  # Update every hour
  timer 60*60, :method => :update

  def on_connect(*)
    @fetcher = CTF::Fetcher.new
    @fetcher.offset = config[:lookahead].to_seconds
    @scheduled_announcements = []
    @credentials = {}
    load_credentials

    self.update
  end

  def on_ctfs(msg)
    list_all_ctfs(msg.channel || msg.user)
  end

  def on_next(msg)
    announce_next(msg.channel || msg.user)
  end

  def on_current(msg)
    list_current_ctfs(msg.channel || msg.user)
  end

  def on_upcoming(msg)
    list_upcoming_ctfs(msg.channel || msg.user)
  end

  def on_creds(msg)
    args = msg.message.match(/creds\s+(\S+)\s+((?:(?<!\\)\\ |\S)+)(?:\s+((?:(?<!\\)\\ |\S)+))?/).to_a
    args.map! do |arg|
      arg.gsub(/\\ /, ' ').gsub(/\\\\/, '\\')
    end
    if args.nil? || args.size < 3
      msg.reply('Usage: `!creds ctf user password` or `!creds ctf key`')
      return
    end
    ctfs = @fetcher.current_ctfs.concat(@fetcher.upcoming_ctfs)
    ctfs = ctfs.select { |c| c['title'].include?(args[1]) }
    if ctfs.size < 1
      msg.reply("Couldn't find any CTF's with that name")
      return
    elsif ctfs.size > 1
      msg.reply("Found #{ctfs.size} events with that name: #{ctfs.map{|c| c['title']}.join(', ')}. Please be more specific")
      return
    end
    ctf = ctfs.first
    @credentials[ctf['title']] = args[2..3]
    msg.reply('Credentials added')
    save_credentials
  end

  # TODO: Refactor with #list_upcoming_ctfs
  def list_current_ctfs(target, notify_empty=true)
    msg = ''
    current_ctfs = @fetcher.current_ctfs
    unless current_ctfs.empty?
      msg << "Current CTF's:\n"
      current_ctfs.each do |ctf|
        msg << CTF.format(ctf, mark_hs: config[:mark_highschool])
        if @credentials.has_key?(ctf['title'])
          creds = @credentials[ctf['title']].reject(&:nil?).map{|x| "'#{x}'"}.join(':')
          msg << " - #{creds}"
        end
        msg << "\n"
      end
    end
    if msg.empty?
      return unless notify_empty
      msg << "There are no current CTF's\n"
    end
    target.send(msg)
  end

  # TODO: Refactor with #list_current_ctfs
  def list_upcoming_ctfs(target, notify_empty=true)
    msg = ''
    upcoming_ctfs = @fetcher.upcoming_ctfs
    unless upcoming_ctfs.empty?
      msg << "Upcoming CTF's in the next #{config[:lookahead]}:\n"
      upcoming_ctfs.each do |ctf|
        msg << CTF.format(ctf, mark_hs: config[:mark_highschool])
        if @credentials.has_key?(ctf['title'])
          creds = @credentials[ctf['title']].reject(&:nil?).map{|x| "'#{x}'"}.join(':')
          msg << " - #{creds}"
        end
        msg << "\n"
      end
    end

    if msg.empty?
      return unless notify_empty
      msg << "There are no upcoming CTF's in the next #{config[:lookahead]}\n"
    end
    target.send(msg)
  end

  def list_all_ctfs(target)
    list_current_ctfs(target, false)
    list_upcoming_ctfs(target)
  end

  def update(*)
    @fetcher.update
    @fetcher.upcoming_ctfs.each do |ctf|
      if @scheduled_announcements.find_index(ctf).nil?
        @scheduled_announcements.push(ctf)
        config[:announce_periods].each do |period|
          announcement_time = ctf['start'].to_time - period.to_i
          timeout = announcement_time - Time.now
          unless timeout < 0
            Timer(timeout, shots: 1) do
              announce_ctf(ctf, period.to_s)
            end
          end
        end
        time_till_start = ctf['start'].to_time - Time.now
        Timer(time_till_start, shots: 1) do
          announce_ctf(ctf, nil)
        end
      end
    end
  end

  def announce_ctf(ctf, time_string, target = nil)
    if time_string.nil?
      msg = "[!] #{CTF.format(ctf, add_dates: false)} is live!"
    else
      msg = "[!] #{CTF.format(ctf, add_dates: false)} starts in #{time_string}"
    end

    if target.nil?
      @bot.channels.each do |chan|
        chan.send(msg)
      end
    else
      target.send(msg)
    end
  end

  def announce_next(target)
    ctf = @fetcher.upcoming_ctfs.sort_by { |c| c['start'].to_time }.first
    time_left = ctf['start'].to_time - Time.now
    time_string = Period.from_seconds(time_left.to_i).to_s(:minutes)
    announce_ctf(ctf, time_string, target)
  end

  def save_credentials
    File.write(CONFIG[:credentials_path], JSON.generate(@credentials))
  end

  def load_credentials
    @credentials = JSON.parse(File.read(CONFIG[:credentials_path]))
  end
end
