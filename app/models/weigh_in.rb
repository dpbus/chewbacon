class WeighIn < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :date, :weight
  
  validates :date, presence: true
  validates :weight, numericality: true
  validates :date, uniqueness: { scope: :user_id, message: "already has a weight recorded for it" }

  def self.dates_from_group(group_id)
    WeighIn.joins(:user => :groups).where("groups.id = ?", group_id).order("date ASC").select(:date).uniq
  end
  
  def display_date
    date.to_date.strftime('%B %d %Y')
  end

end

