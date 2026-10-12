class Message < ApplicationRecord
  has_one :conversation
  belongs_to :conversation
end
