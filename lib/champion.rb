class Champion < ActiveRecord::Base
  has_many :matches
  has_many :summoners, through: :matches

  def pick_rate
    matches_total = Match.all.count/10.0
    matches_picked = self.matches.count
    (matches_picked/matches_total*100).round(2)
  end

  def win_rate
    matches_picked = self.matches.count.to_f
    matches_won = Match.where(win: true, champion_id: self.id).count
    (matches_won/matches_picked*100).round(2)
  end

  def ban_rate
    matches_total = Match.all.count/10.0
    matches_banned = Match.all.where(ban: self.champ_id).count
    (matches_banned/matches_total*100).round(2)
  end

  def self.highest_pick_rate
    champion = Champion.all.max_by {|champion| champion.pick_rate}
    puts "The champion with the highest pick rate is #{champion.name} with a #{champion.pick_rate}% pick rate."
  end

  def self.lowest_pick_rate
    champion = Champion.all.min_by {|champion| champion.pick_rate}
    puts "The champion with the lowest pick rate is #{champion.name} with a #{champion.pick_rate}% pick rate."
  end

  def self.highest_win_rate
    champion = Champion.all.max_by {|champion| champion.win_rate}
    puts "The champion with the highest win rate is #{champion.name} with a #{champion.win_rate}% win rate."
  end

  def self.lowest_win_rate
    champion = Champion.all.min_by {|champion| champion.win_rate}
    puts "The champion with the lowest win rate is #{champion.name} with a #{champion.win_rate}% win rate."
  end

  def self.highest_ban_rate
    champion = Champion.all.max_by {|champion| champion.ban_rate}
    puts "The champion with the highest ban rate is #{champion.name} with a #{champion.ban_rate}% ban rate."
  end

  def self.lowest_ban_rate
    champion = Champion.all.min_by {|champion| champion.ban_rate} #champion.ban_rate == 0 ? 10000 : champion.ban_rate}
    puts "The champion with the lowest ban rate is #{champion.name} with a #{champion.ban_rate}% ban rate."
end
end