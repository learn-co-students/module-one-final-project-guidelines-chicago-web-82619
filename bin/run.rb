require_relative '../config/environment'

# TEST METHODS
def run
  #1st - Get a list of summoner names.
  #2nd - Get the accountId for the first summoner.
  #3rd - Get the matchIds for that accountId.
  names = get_summoner_names
  accountIds = names[0...2].map {|name| get_account_id(name)}
  matchIds = accountIds.map {|accountId| get_match_ids(accountId)}.flatten
  match_data = matchIds[0...10].map {|matchId| get_match_data(matchId)}
  match_data.each {|match_info| create_match(match_info)}
end

run

#write methods
