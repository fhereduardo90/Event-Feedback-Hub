class Event < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1000 }

  has_many :feedbacks, dependent: :destroy
end
