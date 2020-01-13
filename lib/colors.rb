class ColorHex::Colors

  attr_accessor :name, :hex, :rgb

  @@all = []

  def initialize
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

  def self.list_colors
    self.all.each_with_index do |color, i|
      puts "#{i+1}. #{color.name} - #{color.hex} - #{color.rgb}"
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