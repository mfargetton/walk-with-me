class HikingCriterium < ApplicationRecord
  has_many :conversations
  validates :level, presence: :true
end
