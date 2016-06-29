require 'net/http'
require 'json'

require_relative 'ctf'

module CTF
  class Fetcher

    attr_reader :ctfs
    attr_accessor :offset

    def initialize(_offset)
      @ctfs = []
      @offset = _offset
      self.update
    end

    def update()
      start = Time.now.strftime('%s')
      finish = (Time.now + @offset).strftime('%s')
      limit = 100
      uri = URI("https://ctftime.org/api/v1/events/?limit=#{limit}&start=#{start}&finish=#{finish}")
      puts uri
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      data.select! { |ctf| !ctf["onsite"] }

      data.each do |new_ctf|
        already_stored = @ctfs.any? { |ctf| ctf['ctf_id'] == new_ctf['ctf_id'] }
        unless already_stored
          @ctfs.push(CTF.new(new_ctf))
        end
      end
    end
  end
end
