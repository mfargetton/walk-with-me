class Randonnee < ApplicationRecord
  LEVELS = %w[débutant intermédiaire difficile].freeze
  validates :level, presence: true, inclusion: { in: LEVELS }
  validates :duration, presence: true
end
