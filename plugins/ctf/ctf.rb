require_relative '../../util/time'

module CTF
  def self.format(ctf, mark_hs: true, add_dates: true)
    # Example formatted string:
    # 1 Jan - 2 Jan: [HS][Awesome CTF 2016] - https://awesome.ctf
    string = ''
    if add_dates
      time_format = '%-d %b'
      string << '%s - %s: ' % [
        ctf.start.to_time.strftime(time_format).rjust(6),
        ctf.finish.to_time.strftime(time_format).ljust(6),
      ]
    end

    if mark_hs && is_highschool?(ctf)
      string << '[HS]'
    end

    string << '[%s] - %s' % [ctf.title, ctf.url]
  end

  def self.is_highschool?(ctf)
    return !(ctf.description =~ /high\s?school/i).nil?
  end
end
