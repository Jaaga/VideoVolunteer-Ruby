class User < ActiveRecord::Base
  def authenticate?(password)
    BCrypt::Password.new(self.encrypted_password) == password
  end

 # Other useful stuff, like changing password:
  def password_set(password)
    self.encrypted_password = BCrypt::Password.create(password)
  end
end
