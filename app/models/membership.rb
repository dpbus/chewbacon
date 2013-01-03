class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  validates :user, uniqueness: { scope: :group_id, message: "already in that group" }
end
