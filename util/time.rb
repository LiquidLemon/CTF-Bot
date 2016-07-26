require 'time'

class String
  def to_time
    Time.iso8601(self)
  end
end
