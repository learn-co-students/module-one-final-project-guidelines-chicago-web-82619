class Champion < ActiveRecord::Base
  has_many :matches
  has_many :summoners, through: :matches
end