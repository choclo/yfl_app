class UserMailer < ActionMailer::Base
  
  # Email the admin telling them a new user has signed up
  def signup_admin_notification(user)
    setup_email(user)
    @recipients = APP_CONFIG[:admin_email]
    @subject << "New user signup #{user.email}"
  end

  def signup_notification(user)
    setup_email(user)
    @subject << 'Please activate your new account'
    @body[:url] = "#{APP_CONFIG[:site_url]}/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject << 'Your account has been activated!'
    @body[:url] = APP_CONFIG[:site_url]
  end
  
  protected
  
  def setup_email(user)
    @recipients = "#{user.email}"
    @from = APP_CONFIG[:admin_email]
    @bcc = APP_CONFIG[:admin_email]
    @subject = "[#{APP_CONFIG[:site_name]}] "
    @sent_on = Time.now
    @body[:user] = user
  end
  
end
