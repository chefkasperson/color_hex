class ColorHex::Palettes

  attr_accessor :name, :colors

  def initialize
    @colors = []
  end

  def add_color(color)
    @colors << color
  end

end