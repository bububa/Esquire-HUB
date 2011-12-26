class CreateUserStats < ActiveRecord::Migration
  def up
    create_table :user_stats do |t|
      t.date :no
      t.integer :total
      t.integer :finished
      t.integer :delay_material
      t.integer :delay_draft
      t.integer :delay_final
      t.integer :user_id
      t.integer :user_type

      t.timestamps
    end
    add_index :user_stats, [:no, :user_type]
    add_index :user_stats, [:no, :user_id], :unique=>true
    add_index :user_stats, :user_id
  end
  
  def down
    drop_table :user_stats
  end
end
