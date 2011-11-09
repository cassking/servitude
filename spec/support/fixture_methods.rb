module FixtureMethods
  mattr_accessor :user_count
  self.user_count = 0

  def create_user(attributes = {})
    FixtureMethods.user_count += 1
    defaults = { email: "user#{FixtureMethods.user_count}@weblinc.com", password: 'a_password' }
    User.create(defaults.merge(attributes))
  end
end