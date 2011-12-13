# encoding: UTF-8
class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :show, :edit, :update, :destroy] 
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_authenticate, :only => [:index, :destroy]
  
  def index
    @title = "用户管理"
    @users = User.fetch_all
  end
  
  def new
    @user = User.new
    @title = "注册"
  end
  
  def create
    params[:user][:authority] = 0
    @user = User.new(params[:user]) 
    if @user.save
      sign_in @user
      flash[:success] = "欢迎使用 Esquire 广告策划管理系统!"
      redirect_to profile_path
    else
      @title = "注册"
      render 'new'
    end
  end
  
  def show
    if params[:id].nil?
      @user = current_user
    else
      @user = User.fetch(params[:id])
      redirect_to(root_path) unless ( current_user?(@user) || current_user.admin? )
    end
    @title = @user.name
  end
  
  def edit
    @title = "编辑用户"
  end
  
  def update
    if @user.update_attributes(params[:user])
      respond_to do |format|
        format.js {render :json=>@user}
        format.html {
          flash[:success] = "用户信息已经更新"
          redirect_to profile_path
        }
      end
      
    else
      respond_to do |format|
        format.js {render :json=>@user.errors}
        format.html {
          @title = "编辑用户"
          render 'edit'
        }
      end
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "用户已经删除"
    redirect_to users_path
  end
  
  
  private
    
    def correct_user
      if params[:id].nil?
        @user = current_user
      else
        @user = User.find(params[:id])
        redirect_to(root_path) unless ( current_user?(@user) || authorized?([Authority::Admin]) )
      end
    end

end
