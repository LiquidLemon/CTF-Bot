require 'time'

module CTF
  class CTF
    def initialize(ctf_hash)
      @data = ctf_hash
      @data['start'] = Time.iso8601(@data['start'])
      @data['finish'] = Time.iso8601(@data['finish'])
    end
    
    def [](key)
      @data[key]
    end

    def []=(key, value)
      @data[key] = value
    end
    
    def format(mark_hs: true)
      # Example formatted string:
      # 1 Jan - 2 Jan: [HS][Awesome CTF 2016] - https://awesome.ctf
      string = ''
      time_format = '%-d %b'
      string += '%s - %s: ' % [
        @data['start'].strftime(time_format),
        @data['finish'].strftime(time_format),
      ]
      
      string = string.rjust(17)

      if mark_hs && self.is_highschool?
          string += '[HS]'
      end

      string += '[%s] - %s' % [@data['title'], @data['url']]
    end

    def is_highschool?
      return !(@data['description'] =~ /high\s?school/i).nil?
    end
  end
end
