class WeighIn < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :date, uniqueness: { scope: :user_id, message: "already has a weight recorded for it" }
  validates :weight, numericality: true
end
