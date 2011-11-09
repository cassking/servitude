module FixtureMethods
  def create_user(attributes = {})
    User.create({ email: 'user@weblinc.com', password: 'a_password' }.merge(attributes))
  end
end