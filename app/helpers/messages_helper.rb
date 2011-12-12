module MessagesHelper
  def outbox_path
    "#{root_url}messages/out/"
  end
  def message_delete_path(message)
    "#{root_url}message/delete/#{message.id}"
  end
end
