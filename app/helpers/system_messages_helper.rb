module SystemMessagesHelper
  
  def system_message_is_visible(id)
    status = SystemMessageStatus.find(:first, :conditions => { :user_id => current_user, :message_id => id })
    return true if status.nil?
    return status.visible
  end
  
end
