class Message < ApplicationRecord
  has_one :user, through: :conversation
  belongs_to :conversation
  validates :content, presence: :true
end
