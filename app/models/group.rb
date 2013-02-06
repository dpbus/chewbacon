class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  attr_accessible :name, :user_ids
  
  def chart_data
    weigh_ins = WeighIn.where(user_id: users).order(:date)
    keys = []
    h = {}
    weigh_ins.each do |wi|
      keys << wi.user.name
      h[wi.date] = {} unless h.has_key?(wi.date)
      h[wi.date][wi.user.name] = wi.weight
    end
    
    output = []
    h.each do |k, v|
      output << v.merge({'date' => k})
    end
    { data: output, keys: keys.uniq }
  end

  def self.shared_group(user_a, user_b)
    groups_a = Group.joins(:users).where('user_id = ?', user_a).select('groups.id')
    groups_b = Group.joins(:users).where('user_id = ?', user_b).select('groups.id')
    
    if (groups_a & groups_b).length > 0
      return true
    else
      return false
    end  
  end
end
