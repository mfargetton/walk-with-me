class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :user
  belongs_to :hiking_criteria
  validates :title, presence: :true, uniqueness: :true
end
