class CreateArticleStats < ActiveRecord::Migration
  def up
    create_table :article_stats do |t|
      t.date :no
      t.integer :total
      t.integer :finished
      t.integer :delay_material
      t.integer :delay_draft
      t.integer :delay_final

      t.timestamps
    end
    add_index :article_stats, :no, :unique => true
  end
  
  def down
    drop_table :article_stats
  end
end
