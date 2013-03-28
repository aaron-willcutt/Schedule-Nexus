class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  
  attr_accessor :password
  before_save :encrypt_password
  
  #Validate the format and completeness of fields.
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  #validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  
  before_create { generate_token(:auth_token) }
  
  
  #Authenticate user If user exists in the system and has the password 
  #corresponding to the password hash and salt.  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

#Prior to saving password we encrypt using Bcrypt and create the hash and salt.
    def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  #send email upon request of reset password
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  #Used to create unique token for session.  
  def generate_token(column)
  begin
    self[column] = SecureRandom.urlsafe_base64
  end while User.exists?(column => self[column])
end

end
