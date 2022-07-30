require 'test_helper'

class Group::ChartDataTest < ActiveSupport::TestCase
  let(:group) { FactoryBot.create(:group) }

  before(:each) do
    @weigh_ins = Array.new(2) do
      w = FactoryBot.create(:weigh_in, date: Date.today)
      group.users << w.user
      w
    end
  end

  describe "self.new" do
    it "accepts string dates" do
      cd = Group::ChartData.new(group, "2018-01-01", "2018-01-15")
      _(cd.start_date).must_be_instance_of Date
      _(cd.end_date).must_be_instance_of Date
    end

    it "accepts Date dates" do
      cd = Group::ChartData.new(group, Date.current, Date.current)
      _(cd.start_date).must_be_instance_of Date
      _(cd.end_date).must_be_instance_of Date
    end

    it "raises if start > end" do
      _{
        Group::ChartData.new(group, 1.day.from_now, 1.day.ago)
      }.must_raise ArgumentError
    end

    it "handles groups with no end date" do
      group.update_attributes(end_date: nil)
      _(group.chart_data[:keys]).must_include *@weigh_ins.map(&:user).map(&:name)
      _(group.chart_data[:keys].length).must_equal @weigh_ins.length
    end

    it "handles groups with no start date" do
      group.update_attributes(start_date: nil)
      _(group.chart_data[:keys]).must_include *@weigh_ins.map(&:user).map(&:name)
      _(group.chart_data[:keys].length).must_equal @weigh_ins.length
    end

    it "handles groups with no dates" do
      group.update_attributes(start_date: nil, end_date: nil)
      _(group.chart_data[:keys]).must_include *@weigh_ins.map(&:user).map(&:name)
      _(group.chart_data[:keys].length).must_equal @weigh_ins.length
    end
  end

  describe "#for_group" do
    it "returns a map with a list of keys" do
      _(group.chart_data[:keys]).must_include *@weigh_ins.map(&:user).map(&:name)
      _(group.chart_data[:keys].length).must_equal @weigh_ins.length
    end

    it "returns a map with data" do
      expected = {
        "date" => Date.today,
        @weigh_ins[0].user.name => @weigh_ins[0].weight,
        @weigh_ins[1].user.name => @weigh_ins[1].weight,
      }

      _(group.chart_data[:data].length).must_equal 1
      _(group.chart_data[:data].first).must_equal expected
    end


    it "only includes weigh ins for the date range" do
      @weigh_ins.first.update_attributes(date: Date.tomorrow)
      @weigh_ins.last.update_attributes(date: Date.yesterday)
      _(group.chart_data(Date.yesterday, Date.current)[:keys]).wont_include @weigh_ins.first.user.name
      _(group.chart_data(Date.current, Date.tomorrow)[:keys]).wont_include @weigh_ins.last.user.name
    end

    it "handles string dates" do
      _(group.chart_data(1.week.ago.to_s, 1.week.from_now.to_s)[:keys].length).must_equal @weigh_ins.length
    end
  end
end
