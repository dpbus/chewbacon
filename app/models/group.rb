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
  
  def distinct_dates
    distinct_dates = Group.joins(:users => :weigh_ins).select("weigh_ins.date").where(:id => id).uniq
  end
  
  def display_date
    date.to_date.strftime('%B %d %Y')
  end
  
  def value_date
    date.to_date.strftime('%Y-%m-%d')
  end
end
