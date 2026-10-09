class HikingCriterium < ApplicationRecord
  has_many :conversations
  validates :system_prompt, :level, presence: :true
end
