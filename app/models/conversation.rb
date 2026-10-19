class Conversation < ApplicationRecord
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy
  belongs_to :user
  belongs_to :randonnee
end

