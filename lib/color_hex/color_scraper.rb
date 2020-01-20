
class ColorHex::ColorScraper

  attr_accessor :name, :hex, :rgb

  def initialize
    save
  end

  def save
    @@all = self
  end

  def self.scrape
    html = Nokogiri::HTML(open("https://htmlcolorcodes.com/color-names/"))
    doc = html.css("tr.color")
    doc.each do |color|
      new_color = ColorHex::Colors.new
      new_color.html_name = color.css("td h4")[0].text
      new_color.hex = color.css("td h4")[1].text.gsub("#", "")
    end
    end

    def self.import_details(color_object)
      doc = RestClient.get("https://www.thecolorapi.com/id?hex=#{color_object.hex}")
      color_hash = JSON.parse(doc)
      color_object.rgb = color_hash["rgb"]["value"]
      color_object.name = color_hash["name"]["value"]
      color_object.cmyk = color_hash["cmyk"]["value"]
      color_object.hsv = color_hash["hsv"]["value"]
      color_object.image_link = color_hash["image"]["named"]

    end
  # def self.color_scrape
  #   html = Nokogiri::HTML(open("https://htmlcolorcodes.com/color-names/"))
  #   html.css("td.color-name h4").map do |color|
  #     color.text
  #   end
  # end

  # def self.hex_scrape
  #   html = Nokogiri::HTML(open("https://htmlcolorcodes.com/color-names/"))
  #   html.css("td.color-hex.selectable h4").map do |color|
  #     color.text.gsub("#", "")
  #   end
  # end
  
  # def self.import
  #   i = 0
  #   143.times do
  #     doc = RestClient.get("https://www.thecolorapi.com/id?hex=#{hex_scrape[i]}")
  #     color_hash = JSON.parse(doc)
  #     new_color = ColorHex::Colors.new
  #     new_color.html_name = color_scrape[i]
  #     new_color.hex = color_hash["hex"]["clean"]
  #     new_color.rgb = color_hash["rgb"]["value"]
  #     new_color.name = color_hash["name"]["value"]
  #     new_color.cmyk = color_hash["cmyk"]["value"]
  #     new_color.hsv = color_hash["hsv"]["value"]
  #     new_color.image_link = color_hash["image"]["named"]
  #     i += 1
  #   end
    
  # end

end
