class Feedback < ApplicationRecord
  belongs_to :event

  validates :user_name, presence: true, length: { maximum: 100 }
  validates :user_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :feedback_text, presence: true, length: { maximum: 1000 }
  validates :rating, presence: true, inclusion: { in: 1..5 }

  scope :by_event, ->(event_id) { where(event_id: event_id) if event_id.present? }
  scope :by_rating, ->(rating) { where(rating: rating) if rating.present? }
  scope :recent, -> { order(created_at: :desc) }
end
