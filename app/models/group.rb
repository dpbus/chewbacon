class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  attr_accessible :name, :user_ids, :start_date, :end_date
  
  def chart_data(startd = 100.years.ago, endd = Time.zone.now)
#     weigh_ins = WeighIn.where(user_id: users).order(:date)
    
    # make sure filter is within group dates
    if start_date && startd < start_date
      puts "HERE!!!!!!!!!!!!!!!!!!!!!!"
      startd = start_date
    end
    if end_date && endd > end_date
      endd = end_date
    end
    startd = startd.to_s
    endd = endd.to_s
    weigh_ins = WeighIn.where("user_id in (?) and date >= ? and date <= ?",users,Date.parse(startd).beginning_of_day,Date.parse(endd).end_of_day).order(:date)
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
