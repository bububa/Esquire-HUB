# encoding: UTF-8
class ContactsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :index, :show, :edit, :update, :destroy]
  before_filter :correct_user, :only=>[:edit, :update, :destroy]
  
  def new
    @contact = Contact.new
    @careers = Array[*Constants::Careers.collect {|v,i| [v,Constants::Careers.index(v)] }]
    @title = "新联系人"
  end
  
  def create
    @contact = Contact.new(params[:contact]) 
    if @contact.save
      flash[:success] = "新建联系人成功!"
      redirect_to contacts_path
    else
      @careers = Array[*Constants::Careers.collect {|v,i| [v,Constants::Careers.index(v)] }]
      @title = "新联系人"
      render "new"
    end
  end
  
  def edit
    @careers = Array[*Constants::Careers.collect {|v,i| [v,Constants::Careers.index(v)] }]
    @title = "修改联系人"
    render "edit"
  end
  
  def update
    if @contact.update_attributes(params[:contact])
      flash[:success] = "联系人#{@contact.name}已经更新!"
      redirect_to contacts_path
    else
      @careers = Array[*Constants::Careers.collect {|v,i| [v,Constants::Careers.index(v)] }]
      @title = "修改联系人"
      render "edit"
    end
  end
    
  def destroy
    @contact.destroy
    flash[:warning] = "联系人#{@contact.name}已经删除!"
    redirect_to contacts_path
  end
  
  def index
    @contacts = Contact.fetch_by_user_id(current_user.id)
    @title = "联系人列表"
  end
  
  def show
    @contact = Contact.fetch_by_name_and_career_and_user_id(params[:name], params[:career], current_user.id)
    render :json=>@contact
    return
    if stale?(:last_modified => @contact.updated_at.utc, :etag => @contact)
      respond_to do |format|
        format.js {
          render :json=> @contact
        }
      end
    end
  end
  
  private
    def correct_user
      @contact = Contact.find(params[:id])
      redirect_to(root_path) unless ( current_user?(User.fetch(@contact.user_id)) || authorized?([Authority::Admin]) )
    end
    

end
