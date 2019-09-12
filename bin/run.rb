require_relative '../config/environment'
require 'tty-prompt'
require 'colorize'
require_relative '../db/seeds.rb'

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
    "general stats"    => 3,
    "quit"             => 4
  }
  PROMPT.multi_select(greeting, choices)
end

def ask_champion_pick_rate(summoner)
  message = "Please enter a champion name."
  champion_name = PROMPT.ask(message, required: true, convert: :string)
  pick_rate = summoner.pick_rate(champion_name)
  PROMPT.say("Hey #{summoner.name}, you pick #{champion_name} #{pick_rate}% of the time.\n\n")
end

def search_by_summoner
  message = "Please enter a summoner name."
  summoner_name = PROMPT.ask(message, required: true, convert: :string)
  summoner = create_summoner(summoner_name)
  while true  
    instructions = "What would you like to know?"
    choices = {
      "your overall win rate?" => 1,
      "how much you picked a champion?" => 2,
      "champion you picked the most?" => 3,
      "return to main menu" => 4
    }
    choice = PROMPT.multi_select(instructions, choices)[0]
    case choice
    when 1
      win_rate = summoner.win_rate
      PROMPT.say("Hey #{summoner_name}, your win rate is #{win_rate}%.\n\n")
    when 2
      ask_champion_pick_rate(summoner)
    when 3
      most_played = summoner.highest_pick_rate
      PROMPT.say("Hey #{summoner_name}, the champion you pick the most is #{most_played.name} with a #{summoner.pick_rate(most_played.name)}% pick rate.\n\n")
    when 4
      break
    else
    end
  end
end

########## HELPER METHODS - END ##########
def run
  welcome
  sleep(1)
  while true
    search_method = main_menu[0]
    case search_method
    when 1
      search_by_summoner
    when 2
    when 3
    when 4
      break
    end
  end
end

run
