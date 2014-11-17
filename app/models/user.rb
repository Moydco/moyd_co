class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :first_name, type: String
  field :last_name, type: String
  field :opt_in, type: Boolean
  field :opt_in_date, type: DateTime
  field :quickbooks_id, type: String

  attr_accessor :message, :invoice
  attr_accessor :given_name, :family_name, :company_name, :address_line1, :mobile_phone, :fax_phone, :web_site

  has_many :subscriprions

  validates_presence_of :first_name, :last_name
  validates_format_of :email,:with => Devise::email_regexp
  validates_uniqueness_of :email

  validates :opt_in, :acceptance => {:accept => true}

  before_validation :set_password
  before_create :set_opt_in_date
  after_create :add_user_to_mailchimp

  before_destroy :delete_user_from_mailchimp

  def set_opt_in_date
    if opt_in
      self.opt_in_date = DateTime.now
    end
  end

  def set_password
    if (self.password.nil? and self.password.blank?) and (self.password_confirmation.nil? and self.password_confirmation.blank?)
      generated_password = Devise.friendly_token.first(8)
      self.password = generated_password
      self.password_confirmation = generated_password
    end
  end

  def add_user_to_mailchimp
    gb = Gibbon::API.new
    gb.lists.subscribe({:id => Settings.mailchimp_list_id, :email => {:email => self.email}, :merge_vars => {:FNAME => self.first_name, :LNAME => self.last_name}, :double_optin => false})
  end

  def delete_user_from_mailchimp
    gb = Gibbon::API.new
    gb.lists.unsubscribe(:id => Settings.mailchimp_list_id, :email => {:email => self.email}, :delete_member => true, :send_notify => true)
  end
end
