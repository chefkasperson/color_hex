class ColorHex::Colors

  attr_accessor :html_name, :hex, :rgb, :name, :hsv, :cmyk, :image_link

  @@all = []

  def initialize
    @html_name = "none"
    save
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def reset_all
    @@all.clear
  end

  def self.html_colors
    self.all.select do |color|
      color.html_name unless color.html_name == 'none'
    end
  end

  def self.list_html_colors
    self.html_colors.each_with_index do |color, i|
      puts "#{i+1}. #{color.html_name}"
    end
  end

  def self.find_by_hex(hex)
    self.all.detect { |color| color.hex == hex }
  end

  def self.create_by_hex(hex)
    doc = RestClient.get("https://www.thecolorapi.com/id?hex=#{hex}")
    color_hash = JSON.parse(doc)
    new_color = ColorHex::Colors.new
    new_color.hex = color_hash["hex"]["clean"]
    new_color.rgb = color_hash["rgb"]["value"]
    new_color.name = color_hash["name"]["value"]
    new_color.cmyk = color_hash["cmyk"]["value"]
    new_color.hsv = color_hash["hsv"]["value"]
    new_color.image_link = color_hash["image"]["named"]
    new_color
  end

  def self.find_or_create_by_hex(hex)
    find_by_hex(hex) || create_by_hex(hex)
  end

  def group_create_by_hex(hex_array)
    hex_array do |hex|
      create_by_hex(hex)
    end
  end

  def self.list_named_html_colors
    puts <<-DOC
    1. Red
    2. Blue
    3. Green
    4. Yellow
    5. Orange
    DOC
    #lists the named html colors
  end
end