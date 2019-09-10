class Match < ActiveRecord::Base
  belongs_to :champion
  belongs_to :summoner
end