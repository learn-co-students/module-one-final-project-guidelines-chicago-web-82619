require_relative '../config/environment'
require 'tty-prompt'
# TEST METHODS


def intro
  prompt = TTY::Prompt.new
  prompt.ask('What is your name?', default: ENV['USER'])
  prompt.yes?('Do you like Ruby?')
  prompt.select("Choose your destiny?", %w(Irelia Katarina Ekko))
end

intro
#run

#write methods
