class CreateWeighIns < ActiveRecord::Migration[5.2]
  def change
    create_table :weigh_ins do |t|
      t.references :user
      t.decimal :weight
      t.datetime :date
      t.timestamps
    end
  end
end
