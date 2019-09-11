require_relative '../config/environment'
require 'tty-prompt'
# TEST METHODS
def run
  #1st - Get a list of summoner names.
  #2nd - Get the accountId for the first summoner.
  #3rd - Get the matchIds for that accountId.
  names = get_summoner_names
  accountIds = names[0...50].map {|name| get_account_id(name)}
  matchIds = accountIds.map {|accountId| get_match_ids(accountId)}.flatten
  match_data = matchIds[0...100].map {|matchId| get_match_data(matchId)}
  match_data.each {|match_info| create_match(match_info)}
end

def intro
  prompt = TTY::Prompt.new
  prompt.ask('What is your name?', default: ENV['USER'])
  prompt.yes?('Do you like Ruby?')
end

intro
#run

#write methods
