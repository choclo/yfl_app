class AssetsController < ApplicationController

  skip_before_filter :login_required
  skip_before_filter :verify_authenticity_token
  
  def create
    @asset = Asset.new(params[:upload])
    @asset.local_data_content_type = MIME::Types.type_for(@asset.local_data_file_name).to_s
    
    @session = ActiveRecord::SessionStore::Session.find_by_session_id(cookies[ActionController::Base.session_options[:key]])
    current_user = User.find_by_id(@session.data[:user_id])
    
    @asset.pilot_id = current_user.pilot.id
    @asset.attachable_type = params[:attachable_type]
    @asset.attachable_id = params[:attachable_id]
    
    if @asset.save
      render :json => { :result => 'success', :asset => @asset.url(:medium) }
    else
      render :json => { :result => 'error', :error => @asset.errors.full_messages.to_sentence }
    end
  end

  def temp_preview
    @asset = Asset.find_by_id_and_pilot_id(params[:id].to_i, current_pilot.id)
    if !@asset.nil? && !@asset.file_name.nil?
      send_file(@asset.local_data.path(:medium), :type => @asset.content_type, :filename => @asset.file_name) 
    else
      send_file("#{Rails.root}/public/images/assets/missing_medium.png", :type => "image/png", :filename => "missing.png") 
    end
  end
  
end
