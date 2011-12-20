module FixtureMethods
  mattr_accessor :user_count
  self.user_count = 0

  def create_user(attributes = {})
    FixtureMethods.user_count += 1
    defaults = { email: "user#{FixtureMethods.user_count}@weblinc.com", password: 'a_password' }
    User.create(defaults.merge(attributes))
  end

  def create_task(attributes = {})
    defaults = { name: 'Test Task' }
    Task.create(defaults.merge(attributes))
  end

  def create_time_entry(attributes = {})
    TimeEntry.create(attributes)
  end
end
