# encoding: UTF-8
class MessageMailer < ActionMailer::Base
  default from: "esquirehub@gmail.com"
  def new_message_notification(receiver, sender, message)
    @sender = sender
    @receiver = receiver
    @message = message
    mail(:to => "#{receiver.name} <#{receiver.email}>", :subject => "[EsquireHub] #{sender.name} 给您发送一条消息")
  end
end
