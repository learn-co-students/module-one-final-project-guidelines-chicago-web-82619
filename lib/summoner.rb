class Summoner < ActiveRecord::Base
  has_many :matches
  has_many :champions, through: :matches

  def overall_win_rate
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

  def win_rate(champion_name)
    champ = Champion.find_by(name: champion_name)
    num_plays = self.champions.where(name: champion_name).count.to_f
    num_wins = self.matches.where(champion_id: champ.id, win: true).count
    (num_wins/num_plays*100).round(2)
  end

  def ban_rate(champion_name)
    champ = Champion.find_by(name: champion_name)
    num_bans = self.matches.where(ban: champ.champ_id).count
    num_matches = self.matches.count.to_f
    (num_bans/num_matches*100).round(2)
  end

  def highest_pick_rate
    self.champions.uniq.max_by {|champion| self.pick_rate(champion.name)}
  end

  def highest_ban_rate
    self.champions.uniq.max_by {|champion| self.ban_rate(champion.name)}
  end

  def highest_win_rate
    self.champions.uniq.max_by {|champion| self.win_rate(champion.name)}
  end

  def lowest_pick_rate
    self.champions.uniq.min_by {|champion| self.pick_rate(champion.name)}
  end

  def lowest_ban_rate
    self.champions.uniq.min_by {|champion| self.ban_rate(champion.name)}
  end

  def lowest_win_rate
    self.champions.uniq.min_by {|champion| self.win_rate(champion.name)}
  end
end