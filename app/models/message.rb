class Message < ActiveRecord::Base
  attr_accessible :msg, :from_user_id, :to_user_id, :auto, :unread
  belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
  belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"
  
  default_scope :order => 'messages.created_at DESC'
  
  validates :msg,  :presence => true
  
  after_save :after_save
  after_destroy :after_destroy
  
  def self.count_unread(user_id)
    Rails.cache.fetch("User_Message_Count_#{user_id}") do 
      Message.count(:conditions =>["to_user_id=? AND unread=?", user_id, true])
    end
  end
  
  def after_save
    Rails.cache.delete("User_Message_Count_#{self.to_user_id}")
  end

  def after_destroy
    Rails.cache.delete("User_Message_Count_#{self.to_user_id}")
  end
  
end
