class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.date :no
      t.string :brand
      t.integer :pages
      t.string :subject
      t.integer :editor_manager_id
      t.integer :sales_id
      t.integer :editor_id
      t.integer :designer_id
      t.integer :form
      t.integer :position
      t.date :material_on
      t.datetime :material_at
      t.date :draft_on
      t.datetime :draft_at
      t.date :final_on
      t.datetime :final_at
      t.datetime :sales_sign_at
      t.datetime :editor_sign_at
      t.datetime :print_at
      t.text :comment
      t.boolean :canceled
      t.boolean :closed

      t.timestamps
    end
    add_index :articles, :no
    add_index :articles, :brand
    add_index :articles, :editor_manager_id
    add_index :articles, :sales_id
    add_index :articles, :designer_id
    add_index :articles, :canceled
  end
  
  def down
    drop_table :articles
  end
end
