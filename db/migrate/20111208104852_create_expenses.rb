class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :author
      t.string :realname
      t.string :address
      t.string :email
      t.string :idcard
      t.integer :article_id
      t.integer :text_count
      t.float :fee_per_word
      t.integer :pages
      t.float :fee_per_page
      t.float :total_fee
      t.float :tax
      t.float :paid
      t.string :bankno
      t.string :bank
      t.integer :user_id
      t.integer :exp_type
      t.integer :career
      t.text :comment

      t.timestamps
    end
    add_index :expenses, :user_id
    add_index :expenses, :article_id
    add_index :expenses, :exp_type
    add_index :expenses, :career
  end
  
  def down
    drop_table :expenses
  end
end
