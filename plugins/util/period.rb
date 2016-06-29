class Period
  attr_accessor :description, :seconds

  def initialize(desc, s)
    @description = desc
    @seconds = s
  end
end
