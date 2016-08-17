require 'net/http'
require 'json'

require_relative 'ctf'

module CTF
  class Fetcher

    attr_reader :ctfs
    attr_accessor :offset

    def initialize
      @ctfs = []
      self.update
    end

    def update
      # TODO find a proper fix for fetching already running events
      start = (Time.now - 60*60*24*31).strftime('%s')
      limit = 100
      uri = URI("https://ctftime.org/api/v1/events/?limit=#{limit}&start=#{start}")
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      data.select! { |ctf| !ctf["onsite"] }

      data.each do |new_ctf|
        already_stored = @ctfs.any? { |ctf| ctf['ctf_id'] == new_ctf['ctf_id'] }
        unless already_stored
          @ctfs.push(new_ctf)
        end
      end
    end

    def upcoming_ctfs
      max_time = Time.now + @offset
      @ctfs.select do |ctf|
        ctf['start'].to_time > Time.now && ctf['start'].to_time < max_time
      end
    end

    def current_ctfs
      now = Time.now
      @ctfs.select do |ctf|
        ctf['start'].to_time < now && ctf['finish'].to_time > now
      end
    end
  end
end
