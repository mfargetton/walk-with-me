class Randonnee < ApplicationRecord
  LEVELS = %w[débutant intermédiaire difficile].freeze

  has_many :conversations, dependent: :destroy

  validates :level, presence: true, inclusion: { in: LEVELS }
  validates :duration, presence: true

  def summary
    [ level, duration, distance ].compact_blank.join(" · ")
  end
end

