class Group < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  def chart_data(startd = start_date, endd = end_date)
    weigh_ins = WeighIn.select(:date, :user_id, "max(weight) as weight")
      .where(
        date: adjusted_date_range(startd, endd),
        user_id: users,
    ).includes(:user)
      .group(:date, :user_id)
      .order(:date, :user_id)

    data = weigh_ins.reduce({}) do |coll, wi|
      coll[wi.date] ||= {}
      coll[wi.date]["date"] ||= wi.date
      coll[wi.date][wi.user.name] = wi.weight
      coll
    end.values

    {keys: weigh_ins.map(&:user).map(&:name).uniq, data: data}
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

  private

  def adjusted_date_range(startd, endd)
    startd = Date.parse(startd.to_s) rescue nil
    endd   = Date.parse(endd.to_s) rescue nil
    [
      startd,
      start_date,
      Date.new
    ].compact.max.beginning_of_day..
    [
      endd,
        end_date,
        Date.today
    ].compact.min.end_of_day
  end
end
