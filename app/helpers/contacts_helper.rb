module ContactsHelper
  def contact_delete_path(contact)
    "#{root_url}contact/delete/#{contact.id}"
  end
  def contact_edit_path(contact)
    "#{root_url}contact/edit/#{contact.id}"
  end
end
