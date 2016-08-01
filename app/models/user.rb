require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  # Validations
  validates_presence_of :login, :if => :not_using_openid?
  validates_length_of :login, :within => 6..100, :if => :not_using_openid?
  validates_uniqueness_of :login, :case_sensitive => false, :if => :not_using_openid?
  # validates_format_of :login, :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD, :if => :not_using_openid?
  # ADDED: AB: Modifying the login to be an email address
  validates_format_of :login, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD, :if => :not_using_openid?
  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :email, :if => :not_using_openid?, :unless => proc { |rec| rec.errors.on(:login) }
  validates_length_of :email, :within => 6..100, :if => :not_using_openid?, :unless => proc { |rec| rec.errors.on(:login) }
  validates_uniqueness_of :email, :case_sensitive => false, :if => :not_using_openid?, :unless => proc { |rec| rec.errors.on(:login) }
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD, :if => :not_using_openid?, :unless => proc { |rec| rec.errors.on(:login) }
  validates_uniqueness_of :identity_url, :unless => :not_using_openid?
  validate :normalize_identity_url

  # A terms and conditions accessor for the signup process
  attr_accessor :terms
  
  validates_acceptance_of :terms, :message => " and conditions must be accepted", :on => :create
    
  # Relationships
  has_one :pilot
  has_and_belongs_to_many :roles
  
  # Filters
  after_save :flush_passwords
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :identity_url, :terms
  
  # AB: The login is now an email address, use this as an alias
  def email
    login
  end
  
  # Authenticates a user by their email address and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
   u = find_in_state :first, :active, :conditions => { :email => email } # need to get the salt
   u && u.authenticated?(password) ? u : nil
  end
  
  # Check if a user has a role.
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end
  
  # Not using open id
  def not_using_openid?
    identity_url.blank?
  end
  
  # Overwrite password_required for open id
  def password_required?
    new_record? ? not_using_openid? && (crypted_password.blank? || !password.blank?) : !password.blank?
  end

  protected
    
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
  
  def normalize_identity_url
    self.identity_url = OpenIdAuthentication.normalize_url(identity_url) unless not_using_openid?
  rescue URI::InvalidURIError
    errors.add_to_base("Invalid OpenID URL")
  end
  
  # Ensure all the passwords are empty at the end of the processing
  def flush_passwords
    @password = @password_confirmation = nil
  end
end
