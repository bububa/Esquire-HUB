require 'digest'
class User < ActiveRecord::Base
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :authority, :login_at, :logout_at
  has_many :as_sales, :class_name =>"Article", :foreign_key =>"sales_id", :dependent => :destroy
  has_many :as_editor, :class_name =>"Article", :foreign_key =>"editor_id", :dependent => :destroy
  has_many :as_editor_manager, :class_name =>"Article", :foreign_key =>"editor_manager_id", :dependent => :destroy
  has_many :as_designer, :class_name =>"Article", :foreign_key =>"designer_id", :dependent => :destroy
  has_many :expenses, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :as_from_user, :class_name =>"Message", :foreign_key =>"from_user_id", :dependent => :destroy
  has_many :as_to_user, :class_name =>"Message", :foreign_key =>"to_user_id", :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  
  validates :name,  :presence => true,
                    :length => { :maximum => 50 },
                    :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40 },
                        :on => :has_authority?
  
  before_save :encrypt_password, :unless=>:has_authority?
  after_save :after_save
  after_destroy :after_destroy
  
  def self.fetch(id)
    return nil if id.nil?
    Rails.cache.fetch("User_#{id}") do 
      User.find(id)
    end
  end
  
  def self.fetch_all
    Rails.cache.fetch("User_all") do 
      User.all
    end
  end

  def after_save
    Rails.cache.write("User_#{self.id}", self)
    unless self.login_at_changed? || self.logout_at_changed?
      Rails.cache.delete("User_all")
    end
  end

  def after_destroy
    Rails.cache.delete("User_#{self.id}")
    Rails.cache.delete("User_all")
  end
  
  def has_authority?
    !authority.nil?&&!new_record? 
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt) 
    user = User.fetch(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private
    
    def encrypt_password
      self.salt = make_salt if new_record? 
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string) 
      Digest::SHA2.hexdigest(string)
    end
    
end
