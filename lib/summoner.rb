class Summoner < ActiveRecord::Base
  has_many :matches
  has_many :champions, through: :matches

  def win_rate
    matches_played = self.matches.count.to_f
    matches_won = Match.where(win: true, summoner_id: self.id).count
    (matches_won/matches_played*100).round(2)
  end

  def pick_rate(champion_name)
    # Look up a champion by name.
    total_played = self.matches.count.to_f
    champion_played = self.champions.where(name: champion_name).count
    (champion_played/total_played*100).round(2)
  end

  def highest_pick_rate
    most_played = self.champions.uniq.max_by {|champion| self.pick_rate(champion.name)}
    puts "The champion that #{self.name} picked the most is #{most_played.name} with a #{self.pick_rate(most_played.name)}% pick rate."
  end
end