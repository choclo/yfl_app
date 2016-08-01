class SystemMessagesController < ApplicationController
  
  def dismiss
    logger.info params.to_yaml
    @msg = SystemMessageStatus.new :user => current_user, :message_id => params[:message_id], :visible => false
    
    if @msg.save
      head :created
    else
      head :bad_request
    end
  end
  
end
