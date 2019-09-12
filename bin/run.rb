require_relative '../config/environment'
require 'tty-prompt'
require 'colorize'

################ CONSTANTS ###############
PROMPT = TTY::Prompt.new(active_color: :bright_white)
##########################################

########## HELPER METHODS - BEG ##########

def welcome
  line0 = "   _       _     _                _      ".colorize(:color => :light_blue).on_light_white    
  line1 = "  | | ___ | |___| |__   __ _ _ __| | __  ".colorize(:color => :light_blue).on_light_white
  line2 = "  | |/ _ \\| / __| '_ \\ / _` | '__| |/ /  ".colorize(:color => :light_blue).on_light_white
  line3 = "  | | (_) | \\__ \  | | | (_| | |  |   <   ".colorize(:color => :light_blue).on_light_white 
  line4 = "  |_|\\___/|_|___/_| |_|\\__,_|_|  |_|\\_\\  ".colorize(:color => :light_blue).on_light_white
  ascii = line0 + "\n" + line1 + "\n" + line2 + "\n" + line3 + "\n" + line4 + "\n\n"
  message = "Welcome to LolShark, the #1 stats CLI for League of Legends!".colorize(:color => :light_blue).on_light_white
  PROMPT.say(ascii)
  PROMPT.say(message)
end 

def main_menu
  greeting = "Please select a search option!"
  choices = {
    "by summoner name" => 1,
    "by champion name" => 2,
    "general stats"    => 3
  }
  PROMPT.multi_select(greeting, choices)
end

def search_by_summoner
  message = "Please enter a summoner name."
  summoner_name = PROMPT.ask(message, required: true)
  summoner = create_summoner(summoner_name)
  instructions = "What would you like to know?"
  choices = [
    "your overall win rate?",
    "how much you picked a champion?",
    "champion you picked the most?"
  ]
  choice = PROMPT.multi_select(instructions, choices)
end

########## HELPER METHODS - END ##########
def run
  welcome
  sleep(1)
  search_method = main_menu
  #binding.pry
  case search_method
  when 1
    p "i'm aliveeee"
    search_by_summoner
  when 2
  when 3
  else
  end
end

run
