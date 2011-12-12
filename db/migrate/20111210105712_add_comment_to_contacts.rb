class AddCommentToContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :comment, :text
  end
  
  def down
    remove_column :contacts, :comment, :text
  end
end
