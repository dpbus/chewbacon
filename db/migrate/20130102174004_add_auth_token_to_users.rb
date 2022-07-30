class AddAuthTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auth_token, :string
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime
  end
end
