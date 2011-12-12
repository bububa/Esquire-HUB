# encoding: UTF-8
class SessionsController < ApplicationController
  
  def new
    @user = User.new
    @title = "登录"
  end
  
  def create
    @user = User.authenticate(params[:session][:email],
                               params[:session][:password])
    if @user.nil?
      flash.now[:error] = "用户邮件或密码错误."
      @title = "登录"
      render 'new'
    elsif inactivated_user?(@user)
      flash.now[:error] = "用户未激活."
      @title = "登录"
      render 'new'
    else
      @user.login_at = Time.zone.now
      @user.save
      sign_in @user
      if admin_user?
        redirect_to users_path
      else
        redirect_back_or articles_path
      end
    end
  end
  
  def destroy
    user = User.find(current_user.id)
    user.logout_at = Time.zone.now
    user.save
    sign_out
    redirect_to root_path
  end
end
