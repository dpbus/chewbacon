class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  attr_accessible :name, :user_ids
  
  def chart_data(start_date = 100.years.ago, end_date = Time.zone.now)
#     weigh_ins = WeighIn.where(user_id: users).order(:date)
    weigh_ins = WeighIn.where("user_id in (?) and date >= ? and date <= ?",users,start_date.beginning_of_day,end_date.end_of_day).order(:date)
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
