class Period

  UNIT_MULTIPLIERS = {
    :weeks => 604800,
    :days => 86400,
    :hours => 3600,
    :minutes => 60,
    :seconds => 1
  }

  def initialize(units)
    @units = units
  end

  def self.from_seconds(seconds)
    units = {}
    UNIT_MULTIPLIERS.each_pair do |unit, multiplier|
      unless seconds < multiplier
        units[unit] = seconds / multiplier
        seconds %= multiplier
      end
    end
    return self.new(units)
  end

  def to_seconds
    @units.reduce(0) do |acc, (key, val)|
      acc += val * UNIT_MULTIPLIERS[key]
    end
  end
  alias_method :to_i, :to_seconds

  def to_s(accuracy = :s)
    descriptions = @units.reduce([]) do |acc, (desc, val)|
      unless val == 0
        str = desc.to_s
        str = str[0...-1] if val == 1
        acc << "#{val} #{str}"
      end
    end

    descriptions.each_with_index.reduce('') do |acc, (desc, i)|
      left = descriptions.length - i
      case left
      when 1
        acc << desc
      when 2
        acc << "#{desc} and "
      else
        acc << "#{desc}, "
      end
    end

  end
end
