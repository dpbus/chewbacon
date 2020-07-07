class Group
  class ChartData
    attr_reader :start_date, :end_date

    def initialize(group, startd, endd)
      @start_date = Date.parse(startd.to_s) rescue nil
      @end_date   = Date.parse(endd.to_s) rescue nil

      raise ArgumentError.new("End date must be after start date") if @start_date > @end_date
    end

    def for_group(group)
      weigh_ins = WeighIn.select(:date, :user_id, "max(weight) as weight")
        .where(
          date: adjusted_date_range(group),
          user_id: group.users,
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
  end
end
