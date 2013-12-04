class AddStartAndEndDatesToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :start_date, :datetime
    add_column :groups, :end_date, :datetime
    
    add_index :groups, :start_date
    add_index :groups, :end_date
  end
end
