

class ColorHex::CLI

  attr_accessor = :search_result, :color, :html_colors, :page

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
    welcome
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
      puts '  Here is the list of named html colors'
      html_colors_list_array
      html_list
    when '2'
      puts '  Please enter the hexadecimal color code you would like to search for:'
      hex_options
    when '3'
      search_options
    when '4'
      save_options
    when 'exit'
      goodbye
    else
      welcome
    end
    
  end
  
  def welcome
    welcome_options
    welcome_selection
  end

  def html_colors_list_array
    @html_colors = []
    @page = 1
    ColorHex::Colors.html_colors.each_with_index do |color, i|
      @html_colors << "  #{i+1}. #{color.html_name}"
    end
  end
  
  def html_list

    case @page
    when 1
      puts @html_colors[0...25]
      html_color_options
    when 2
      puts @html_colors[25...50]
      html_color_options
    when 3
      puts @html_colors[50...75]
      html_color_options
    when 4
      puts @html_colors[75...100]
      html_color_options
    when 5
      puts @html_colors[100...125]
      html_color_options
    when 6
      puts @html_colors[125..143]
      html_color_options
    else
      @page = 1
      html_list
    end

  end

  def html_color_options
    puts <<-DOC
    Please enter the number of the color you would like more information on: OR
    Type 'n' to see more results, 'p' to see previous results
    Type 'menu' for main menu, 'list' to return to the previous list, or 'exit' to exit  
    DOC

    html_input = gets.strip

    if html_input.to_i.between?(1, ColorHex::Colors.html_colors.length)
      @color = ColorHex::Colors.html_colors[html_input.to_i-1]
      color_description(@color)
      puts "  Enter 'save' to store the color"
      html_color_options
    elsif html_input == 'n'
      @page += 1
      html_list
    elsif html_input == 'p'
      @page -= 1
      html_list
    elsif html_input == 'save'
      @color.store
      puts '  The color was saved'
      html_color_options
    elsif html_input == 'menu'
      welcome
    elsif html_input == 'list'
      html_list
    elsif html_input == 'exit'
      goodbye
    else
      puts '  Please try again'
      html_color_options
    end

  end

  def hex_options
    puts '  Enter a Hex code to find more information:'
    hex_input = gets.strip
    
    if hex_input.gsub(/[0-9a-fA-F]{6}/, '') == ''
      @color = ColorHex::Colors.find_or_create_by_hex(hex_input)
      color_description(@color)
      puts "  Enter 'save' to store the color"
      hex_options
    elsif hex_input == 'save'
      @color.store
      puts '  The color was saved'
      hex_options
    elsif hex_input == 'exit'
      goodbye
    elsif hex_input == 'menu'
      welcome
    else 
      puts '  Please try again'
      hex_options
    end
  end
  
  def search_options
    puts '  What keyword would you like to use:'
    
    search_input = gets.strip
    
    if search_input == 'exit'
      goodbye
    elsif search_input == 'menu'
      welcome   
    elsif search_input.length > 2 && search_input.gsub(/[A-Za-z]+/, '') == ''
      @search_result = ColorHex::Colors.all.select do |color|
        color.html_name.downcase.include?(search_input.downcase) || color.name.include?(search_input.downcase)
      end
      search_options_2
    else
      puts '  Please enter a valid input'
      search_options
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
    puts '  Enter the number for more information about the color'
    selection = gets.strip
    
    if selection.to_i.between?(1, @search_result.length)
      @color = @search_result[selection.to_i-1]
      color_description(@color)
      puts ''
      puts <<-DOC
      Enter 'menu' for main menu, 'result' to see the last search result, 'save' to store the result,
      'new' for a new search, 'exit' to leave
      DOC
      search_options_3
    elsif selection == 'result'
      search_options_2
    elsif selection == 'new'
      search_options
    elsif selection == 'save'
      @color.store
      puts '  The color was saved'
      search_options_3
    elsif selection == 'exit'
      goodbye
    elsif selection == 'menu'
      welcome
    else
      search_options_3
    end
  end

  def display_search_result
    @search_result.uniq.each_with_index do |color, i|
      puts "  #{i+1}. #{color.name}"
    end
  end
  
  def save_options
    if ColorHex::Colors.storage.count > 0
      puts ''
      puts "  Here are the colors you have saved:"
      save_list
    else
      puts ''
      puts "  You do not have any colors saved"
      welcome
    end
    save_options_2
  end
  
  def save_options_2
    puts <<-DOC
    Enter the number to view the color, Enter 'u' to unsave a color, Enter 'clear' to unsave all colors
    Enter 'menu' for main menu, Enter 'exit' to exit
    DOC
    save_input = gets.strip

    if save_input == 'menu'
      welcome
    elsif save_input == 'exit'
      goodbye
    elsif save_input == 'clear'
      ColorHex::Colors.clear_store
      welcome
    elsif save_input == 'u'
      unsave_color
      save_options
    elsif save_input.to_i.between?(1, ColorHex::Colors.storage.length)
      @color = ColorHex::Colors.storage[save_input.to_i - 1]
      color_description(@color)
      save_options_2
    else
      puts "  I did not understand"
      save_options
    end 
  end

  def unsave_color
    puts ''
    puts '  Choose color you would like to delete'
    unsave_input = gets.strip
    if unsave_input.to_i.between?(1, ColorHex::Colors.storage.length)
      @color = ColorHex::Colors.storage[unsave_input.to_i - 1]
      ColorHex::Colors.storage.delete(@color)
      puts '  Your color was deleted'
      save_options
    elsif unsave_input == 'exit'
      goodbye
    elsif unsave_input == 'menu'
      welcome
    else
      unsave_color
    end
  end
  
  def save_list
    ColorHex::Colors.storage.each_with_index do |color, i|
      puts "  #{i+1} #{color.name}"
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

  def goodbye
    puts "  Thank you"
    exit
  end
  
end