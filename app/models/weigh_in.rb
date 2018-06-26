class WeighIn < ActiveRecord::Base
  belongs_to :user

  attr_accessible :date, :weight

  validates :date, presence: true
  validates :weight, numericality: true
  validates :date, uniqueness: { scope: :user_id, message: "already has a weight recorded for it" }
end
