class AddLoginAtToUsers < ActiveRecord::Migration
  def up
    add_column :users, :login_at, :datetime
    add_column :users, :logout_at, :datetime
  end
  
  def down
    remove_column :users, :login_at, :datetime
    remove_column :users, :logout_at, :datetime
  end
end
