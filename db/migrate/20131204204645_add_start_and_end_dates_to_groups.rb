class AddStartAndEndDatesToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :start_date, :datetime
    add_column :groups, :end_date, :datetime

    add_index :groups, :start_date
    add_index :groups, :end_date
  end
end
