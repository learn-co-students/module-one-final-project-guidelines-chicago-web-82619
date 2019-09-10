class Summoner < ActiveRecord::Base
  has_many :matches
  has_many :champions, through: :matches
end