require_relative './color_hex'
require 'pry'
require 'nokogiri'
require 'open-uri'
require 'rest-client'
require 'json'

class ColorHex::ColorScraper

  attr_accessor :name, :hex, :rgb

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
      color.text.gsub("#", "")
    end
  end

  # def self.rgb_scrape
  #   html = Nokogiri::HTML(open("https://htmlcolorcodes.com/color-names/"))
  #   html.css("td.color-rgb.selectable h4").map do |color|
  #     color.text
  #   end
  # end

  # doc = RestClient.get("https://www.thecolorapi.com/id?hex=#{hex}")
  # color_hash = JSON.parse(doc)
  # new_color = ColorHex::Colors.new
  # new_color.hex = color_hash["hex"]["clean"]
  # new_color.rgb = color_hash["rgb"]["value"]
  # new_color.name = color_hash["name"]["value"]
  # new_color.cmyk = color_hash["cmyk"]["value"]
  # new_color.hsv = color_hash["hsv"]["value"]
  # new_color.image_link = color_hash["image"]["named"]

  def self.import
    i = 0
    143.times do
      doc = RestClient.get("https://www.thecolorapi.com/id?hex=#{hex_scrape[i]}")
      color_hash = JSON.parse(doc)
      new_color = ColorHex::Colors.new
      new_color.html_name = color_scrape[i]
      new_color.hex = color_hash["hex"]["clean"]
      new_color.rgb = color_hash["rgb"]["value"]
      new_color.name = color_hash["name"]["value"]
      new_color.cmyk = color_hash["cmyk"]["value"]
      new_color.hsv = color_hash["hsv"]["value"]
      new_color.image_link = color_hash["image"]["named"]
      i += 1
    end
    
  end

end
