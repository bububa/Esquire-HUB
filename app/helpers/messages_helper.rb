module MessagesHelper
  def outbox_path
    "#{root_url}messages/out/"
  end
  def inbox_path
    "#{root_url}messages/in/"
  end
  def messages_all_path
    "#{root_url}messages/all/"
  end
  def message_delete_path(message, box)
    box = 'chat' if box.nil?
    "#{root_url}message/delete/#{message.id}/#{box}"
  end
end
