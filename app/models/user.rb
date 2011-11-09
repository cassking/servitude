class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, required: true, format: :email_address, unique: true
  property :password, BCryptHash, required: true
  
  def self.get_authenticated(email, password)
    user = all(email: email).first
    user.authenticate?(password) ? user : nil if user
  end
  
  def authenticate?(password)
    self.password == password
  end
end
