# encoding: UTF-8

require 'pubnub'

class MessagesController < ApplicationController
  before_filter :authenticate, :only => [:index, :create, :destroy, :read]
  before_filter :correct_user, :only=>[:destroy, :read]
  
  def unread_count
    count = Message.count_unread(current_user.id)
    if count == 0
      expires_in 24.hours, :public => true
    end
    render :json=>{:unread=>count}
  end
  
  def index
    @message = Message.new
    @users = Array[*User.fetch_all.select{ |x| !admin_user?(x)&&!current_user?(x) }.collect {|v,i| [v.name, v.id] }]
    if params[:box] == "out"
      @conditions = ["from_user_id=?", current_user.id]
    else
      @conditions = ["to_user_id=?", current_user.id]
    end
    @messages = Message.paginate(:page => params[:page], :per_page => @per_page, :conditions => @conditions)
    @title = "消息中心"
  end
  
  def mark_read
    Message.update_all({:unread=>false}, {:id=>params[:ids]})
    logger.debug("User_Message_Count_#{current_user.id}")
    Rails.cache.delete("User_Message_Count_#{current_user.id}")
    render :json=>{:ids=>params[:ids]}
  end
  
  def create
    params[:message][:from_user_id] = current_user.id
    params[:message][:unread] = true
    @message = Message.new(params[:message]) 
    if @message.save
      flash[:success] = "消息发成功!"
      count = Message.count_unread(@message.to_user_id)
      #MessagesController.publish("user_message_count_#{@message.to_user_id}", {"unread"=>count.to_s})
    else
      flash[:error] = "消息发送失败!"
    end
    redirect_to messages_path
  end
  
  def destroy
    @message.destroy
    flash[:warning] = "已经删除!"
    redirect_to messages_path
  end
  
  def read
    if @message.update_attributes(:unread=>false)
      render :json=>@message
    else
      render :json=>nil
    end
  end
  
  def self.publish(channel, msg)
    publish_key   = ENV['PUBNUB_PUBLISH_KEY'] || 'demo'
    subscribe_key = ENV['PUBNUB_SUBSCRIBE_KEY'] || 'demo'
    secret_key    = ENV['PUBNUB_SECRET_KEY'] || ''
    ssl_on        = false
    
    pubnub = Pubnub.new(
        publish_key,
        subscribe_key,
        secret_key,
        ssl_on
    )
    
    info = pubnub.publish({
        'channel' => channel,
        'message' => msg
    })
  end
  
  private
    def correct_user
      @message = Message.find(params[:id])
      if params.has_key?(:read)
        redirect_to(root_path) unless current_user?(User.fetch(@message.to_user_id))
      else
        redirect_to(root_path) unless ( current_user?(User.fetch(@message.from_user_id)) || authorized?([Authority::Admin]) || !@message.unread )
      end
    end
end
