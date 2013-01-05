class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  validates :user_id, uniqueness: { scope: :group_id, message: "is already in that group" }
end
