class Period

  def initialize(weeks: 0, days: 0, hours: 0)
    @periods = {}
    @periods[:weeks] = weeks
    @periods[:days] = days
    @periods[:hours] = hours
  end

  def to_seconds
    secs = @periods[:weeks] * 7 * 24 * 60 * 60
    secs += @periods[:days] * 24 * 60 * 60
    secs += @periods[:hours] * 60 * 60
    return secs
  end
  alias_method :to_i, :to_seconds

  def to_s
    descriptions = []
    @periods.each_pair do |k, v|
      unless v == 0
        str = k.to_s
        str = str[0...-1] if v == 1
        descriptions << "#{v} #{str}"
      end
    end
    str = ''
    descriptions.each_with_index do |desc, i|
      left = descriptions.length - i
      case left
      when 1
        str << desc
      when 2
        str << "#{desc} and "
      else
        str << "#{desc}, "
      end
    end
    return str
  end
end
