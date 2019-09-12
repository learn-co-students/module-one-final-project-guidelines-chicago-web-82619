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
  PROMPT.select(greeting) do |menu|
    menu.choice "by summoner name", 1
    menu.choice "by champion name", 2
    menu.choice "general stats", 3
    menu.choice "quit", 4
  end
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
    choice = PROMPT.select(instructions) do |menu|
      menu.choice "your overall win rate?", 1
      menu.choice "how much you picked a champion?", 2
      menu.choice "champion you picked the most?", 3
      menu.choice "return to main menu", 4
    end
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

def search_by_champion
  message = "Please enter a champion name."
  champion_name = PROMPT.ask(message, required: true, convert: :string)
  champion = Champion.find_by(name: champion_name)
  while true  
    instructions = "What would you like to know?"
    choice = PROMPT.select(instructions) do |menu|
      menu.choice "the champion's overall win rate?", 1
      menu.choice "how often the champion was picked?", 2
      menu.choice "how often the champion was banned?", 3
      menu.choice "return to main menu", 4
    end
    case choice
    when 1
      win_rate = champion.win_rate
      PROMPT.say("#{champion_name} has a #{win_rate}% win rate.\n\n")
    when 2
      pick_rate = champion.pick_rate
      PROMPT.say("#{champion_name} has a #{pick_rate}% pick rate.\n\n")
    when 3
      ban_rate = champion.ban_rate
      PROMPT.say("#{champion_name}, has a ban rate of #{ban_rate}%.\n\n")
    when 4
      break
    else
    end
  end
end

def search_database
  while true  
    instructions = "What would you like to know?"
    choice = PROMPT.select(instructions) do |menu|
      menu.choice "the champion with the highest overall win rate?", 1
      menu.choice "the champion with the lowest overall win rate?", 2
      menu.choice "the champion with the highest overall pick rate?", 3
      menu.choice "the champion with the lowest overall pick rate?", 4
      menu.choice "the champion with the highest overall ban rate?", 5
      menu.choice "the champion with the lowest overall ban rate?", 6
      menu.choice "return to main menu", 7
    end
    case choice
    when 1
      winner = Champion.highest_win_rate 
      PROMPT.say("#{winner.name} has the highest win rate with a #{winner.win_rate}% win rate.\n\n")
    when 2
      loser = Champion.lowest_win_rate 
      PROMPT.say("#{loser.name} has the lowest win rate with a #{loser.win_rate}% win rate.\n\n")
    when 3
      winner = Champion.highest_pick_rate 
      PROMPT.say("#{winner.name} is picked the most with a #{winner.pick_rate}% pick rate.\n\n")
    when 4
      loser = Champion.lowest_pick_rate
      PROMPT.say("#{loser.name} is picked the least with a #{loser.pick_rate}% pick rate.\n\n")
    when 5
      most_banned = Champion.highest_ban_rate
      PROMPT.say("#{most_banned.name} is banned the most with a #{most_banned.ban_rate}% ban rate.\n\n")
    when 6
      least_banned = Champion.lowest_ban_rate
      PROMPT.say("#{least_banned.name} is banned the least with a #{least_banned.ban_rate}% ban rate.\n\n")
    when 7
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
    search_method = main_menu
    case search_method
    when 1
      search_by_summoner
    when 2
      search_by_champion
    when 3
      search_database
    when 4
      break
    end
  end
end

run
