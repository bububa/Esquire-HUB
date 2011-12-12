class CreateMessages < ActiveRecord::Migration
  def up
    create_table :messages do |t|
      t.text :msg
      t.integer :from_user_id
      t.integer :to_user_id
      t.boolean :auto
      t.boolean :unread

      t.timestamps
    end
    
    add_index :messages, :unread
    add_index :messages, :from_user_id
    add_index :messages, :to_user_id
  end
  
  def down
    drop_table :messages
  end
  
end
