class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.integer :authority

      t.timestamps
    end
    add_index :users, :email, :unique => true
    add_index :users, :name, :unique => true
  end
  
  def down
    drop_table :users
  end
end
