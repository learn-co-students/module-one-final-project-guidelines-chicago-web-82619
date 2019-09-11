require_relative '../config/environment'
require 'tty-prompt'
require 'colorize'

################ CONSTANTS ###############
PROMPT = TTY::Prompt.new(active_color: :bright_white)
##########################################

########## HELPER METHODS - BEG ##########
def welcome
  line0 = "       __             __  ______ __                    __   __   ".colorize(:color => :light_blue).on_light_white  
  line1 = "      /_/            /_/ /_/_/_//_/                   /_/  /_/   ".colorize(:color => :light_blue).on_light_white  
  line2 = "     /_/      ____  /_/ /_/___ /_/___ ______  ______ /_/ /_/     ".colorize(:color => :light_blue).on_light_white    
  line3 = "    /_/      /_/_/ /_/ /_/_/_//_/_/_//_/_/_/ /_/_/_//_//_/       ".colorize(:color => :light_blue).on_light_white     
  line4 = "   /_/____ /_/ /_//_/ __  /_//_/ /_//_/ /_/ /_/ /_//_/ /_/       ".colorize(:color => :light_blue).on_light_white     
  line5 = "  /_/_/_/_//_/_/ /_/ /_/_/_//_/ /_//_/_/\\_//_/    /_/   /_/      ".colorize(:color => :light_blue).on_light_white  
  ascii = line0 + "\n" + line1 + "\n" + line2 + "\n" + line3 + "\n" + line4 + "\n" + line5 + "\n\n"
  message = "Welcome to LolShark, the #1 stats site for League of Legends!".colorize(:color => :light_blue).on_light_white
  PROMPT.say(ascii)
  PROMPT.say(message)
end

def 

########## HELPER METHODS - END ##########
def run
  welcome
end

run
