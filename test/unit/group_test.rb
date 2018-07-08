require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  let(:group) { FactoryBot.create(:group) }

  describe "#chart_data" do
    before(:each) do
      @weigh_ins = Array.new(2) do
        w = FactoryBot.create(:weigh_in, date: Date.today)
        group.users << w.user
        w
      end
    end

    it "returns a map with a list of keys" do
      group.chart_data[:keys].must_include *@weigh_ins.map(&:user).map(&:name)
      group.chart_data[:keys].length.must_equal @weigh_ins.length
    end

    it "returns a map with data" do
      expected = {
        "date" => Date.today,
        @weigh_ins[0].user.name => @weigh_ins[0].weight,
        @weigh_ins[1].user.name => @weigh_ins[1].weight,
      }

      group.chart_data[:data].length.must_equal 1
      group.chart_data[:data].first.must_equal expected
    end
  end
end
