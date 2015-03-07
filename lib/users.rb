class User < ActiveRecord::Base
  before_save { email.downcase! }
  before_save { first_name.capitalize! }
  before_save { last_name.capitalize! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }


  def authenticate?(password)
    BCrypt::Password.new(self.encrypted_password) == password
  end

  def password_set(password)
    self.encrypted_password = BCrypt::Password.create(password)
  end
end
