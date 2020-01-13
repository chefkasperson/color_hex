require_relative './color_hex'
require 'pry'
require 'nokogiri'
require 'open-uri'

class ColorHex::ColorScraper

  attr_accessor :name, :hex, :rgb

  @@name = []
  @@hex = []
  @@rgb = []

  def initialize
    save
  end

  def save
    @@all = self
  end

  def self.color_scrape
    html = Nokogiri::HTML(open("https://htmlcolorcodes.com/color-names/"))
    html.css("td.color-name h4").map do |color|
      color.text
    end
  end

  def self.hex_scrape
    html = Nokogiri::HTML(open("https://htmlcolorcodes.com/color-names/"))
    html.css("td.color-hex.selectable h4").map do |color|
      color.text
    end
  end

  def self.rgb_scrape
    html = Nokogiri::HTML(open("https://htmlcolorcodes.com/color-names/"))
    html.css("td.color-rgb.selectable h4").map do |color|
      color.text
    end
  end

  def scrape_all
    color_scrape
    hex_scrape
    rgb_scrape
  end

  def self.name
    @@name
  end

  def self.hex
    @@hex
  end

  def self.rgb
    @@rgb
  end

  def self.import
    i = 0
    143.times do
      x = ColorHex::Colors.new
      x.name = color_scrape[i]
      x.hex = hex_scrape[i]
      x.rgb = rgb_scrape[i]
      i += 1
    end
    
  end

end
