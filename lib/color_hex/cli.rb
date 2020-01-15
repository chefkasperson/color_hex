

class ColorHex::CLI

  attr_accessor = :search_result

  def call
    puts "Welcome to ..."
    puts <<-DOC

     ____ ___  _     ___  ____    _   _ _______  __
    / ___/ _ \\| |   / _ \\|  _ \\  | | | | ____\\ \\/ /
   | |  | | | | |  | | | | |_) | | |_| |  _|  \\  /
   | |__| |_| | |__| |_| |  _ <  |  _  | |___ /  \\
    \\____\\___/|_____\\___/|_| \\_\\ |_| |_|_____/_/\\_\\


    DOC
    ColorHex::ColorScraper.import
    welcome_options
    welcome_selection
    goodbye
    
  end
  
  def welcome_options
    puts <<-DOC 
    Please select one of the following options:
    
    1. List all the named html colors.
    2. Search for a color based on the hex value.
    3. Search for a color based on a keyword.
    4. To view saved colors
    Type 'exit' to leave.
    DOC

  end

  def welcome_selection
  
    welcome_input = gets.strip

    case welcome_input
    when '1'
      puts 'Here is the list of named html colors'
      ColorHex::Colors.list_html_colors
      html_color_options
    when '2'
      puts 'Please enter the hexadecimal color code you would like to search for:'
      hex_options
    when '3'
      search_options
    when '4'
      save_options
    when 'exit'
      goodbye
    else
      welcome_options
      welcome_selection
    end
    
  end

  def search_options
    puts 'What keyword would you like to use:'

    search_input = gets.strip
    
    if search_input == 'exit'
      goodbye
    elsif search_input == 'menu'
      welcome_options
      welcome_selection    
    elsif search_input.length > 2 && search_input.gsub(/[A-Za-z]+/, '') == ''
      @search_result = ColorHex::Colors.all.select do |color|
        color.html_name.downcase.include?(search_input.downcase) || color.name.include?(search_input.downcase)
      end
      search_options_2
    else
      puts 'Please enter a valid input'
      search_options
    end
  end
  
  def display_search_result
    @search_result.uniq.each_with_index do |color, i|
      puts "#{i+1}. #{color.name}"
    end
  end

  def search_options_2
    if @search_result == nil || @search_result == []
      puts 'No results found'
      search_options
    else
      display_search_result
      search_options_3
    end
  end

  def search_options_3
    puts 'Enter the number for more information about the color'
    selection = gets.strip
    
    if selection.to_i.between?(1, @search_result.length)
      color_description(@search_result[selection.to_i-1])
      puts ''
      puts "Enter 'menu' for main menu, 'result' to see the last search result, 'new' for a new search, 'exit' to leave"
      search_options_3
    elsif selection == 'result'
      search_options_2
    elsif selection == 'new'
      search_options
    elsif selection == 'exit'
      goodbye
    elsif selection == 'menu'
      welcome_options
      welcome_selection
    else
      search_optons_3
    end
  end

  def html_color_options
    puts <<-DOC
    Please enter the number of the color you would like more information on: OR
    Type 'menu' for main menu, 'list' to return to the previous list, or 'exit' to exit  
    DOC

    html_input = gets.strip

    if html_input.to_i.between?(1, ColorHex::Colors.html_colors.length)
      color = ColorHex::Colors.html_colors[html_input.to_i-1]
      color_description(color)
      html_color_options
    elsif html_input == 'menu'
      welcome_options
      welcome_selection
    elsif html_input == 'list'
      ColorHex::Colors.list_html_colors
      html_color_options
    elsif html_input == 'exit'
      goodbye
    else
      puts 'Please try again'
      html_color_options
    end

  end

  def color_description(color_object)
    puts <<-DOC
    Name: #{color_object.name}
    HTML Name: #{color_object.html_name}
    Hex Value: #{color_object.hex}
    RGB Value: #{color_object.rgb}
    HSV Value: #{color_object.hsv}
    CMYK Value: #{color_object.cmyk}
    Image Link: #{color_object.image_link}
    DOC

  end

  def hex_options
    puts 'Enter a Hex code to find more information:'
    hex_input = gets.strip
    
    if hex_input.gsub(/[0-9a-fA-F]{6}/, '') == ''
      color = ColorHex::Colors.find_or_create_by_hex(hex_input)
      color_description(color)
      hex_options
    elsif hex_input == 'exit'
      goodbye
    elsif hex_input == 'menu'
      welcome_options
      welcome_selection
    else 
      puts 'Please try again'
      hex_options
    end
  end

  def goodbye
    puts "Thank you"
    exit
  end
  
end