

class ColorHex::CLI

  def call
    puts "Welcome to Color Hex"
    ColorHex::ColorScraper.import
    welcome_options
    goodbye
    
    
  end
  
  def welcome_options
    puts <<-DOC 
    Please select one of the following options:
    
    1. List all the named html colors.
    2. Search for a color based on the hex value.
    3. Find color schemes based on a color.
    Type 'exit' to leave anytime
    DOC

    welcome_input = nil

    while welcome_input != "exit" do
      
      welcome_input = gets.strip

      case welcome_input
      when "1"
        puts "Here is the list of named html colors"
        ColorHex::Colors.list_colors
      when "2"
        puts "Please enter the color's hexadecimal code you would like to search for:"
      when "3"
        puts "What color would you like to find pairings for?"
      end
    end
  end

  def goodbye
    puts "Thank you"
  end
  
  
  
  
  
  
end