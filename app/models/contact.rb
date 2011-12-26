class Contact < ActiveRecord::Base
  attr_accessible :name, :realname, :address, :email, :idcard, :bankno, :bank, :user_id, :career, :comment
  belongs_to :user
  
  validates :name,  :presence => true
  validates_uniqueness_of :name, :scope => [:career, :user_id]
  validates_uniqueness_of :idcard, :scope => [:career, :user_id]
  
  after_save :after_save
  after_destroy :after_destroy
  
  def self.fetch(id)
    Rails.cache.fetch("Contact_#{id}") do 
      Contact.find(id)
    end
  end
  
  def self.fetch_by_name_and_career_and_user_id(name, career, user_id)
    Rails.cache.fetch("Contact_#{name}_#{career}_#{user_id}") do 
      Contact.find_by_name_and_career_and_user_id(name, career, user_id)
    end
  end
  
  def self.fetch_by_user_id(user_id)
    Rails.cache.fetch("Contact_UserID#{user_id}") do 
      Contact.where("user_id=?", user_id).all
    end
  end

  def after_save
    Rails.cache.write("Contact_#{self.name}_#{self.career}_#{self.user_id}", self)
    Rails.cache.write("Contact_#{self.id}", self)
    Rails.cache.delete("Contact_UserID#{self.user_id}")
  end

  def after_destroy
    Rails.cache.delete("Contact_#{self.name}_#{self.career}_#{self.user_id}", self)
    Rails.cache.delete("Contact_#{self.id}")
    Rails.cache.delete("Contact_UserID#{self.user_id}")
  end
  
end
