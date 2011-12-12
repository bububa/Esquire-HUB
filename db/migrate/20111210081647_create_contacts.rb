class CreateContacts < ActiveRecord::Migration
  def up
    create_table :contacts do |t|
      t.string :name
      t.string :realname
      t.string :address
      t.string :email
      t.string :idcard
      t.string :bankno
      t.string :bank
      t.integer :career
      t.integer :user_id

      t.timestamps
    end
    add_index :contacts, [:name, :career, :user_id], :unique => true
    add_index :contacts, [:idcard, :career, :user_id], :unique => true
  end
  
  def down
    drop_table :contacts
  end
end
