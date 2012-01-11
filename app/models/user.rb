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

  def start_task(task_id)
    return if task_id == current_task_id

    stop_task
    self.current_task_id = task_id
    self.task_started_at = Time.now
    save
  end

  def stop_task
    self.current_task = nil
    self.task_started_at = nil

    TimeEntry.create(
      user_id:  id,
      task_id:  current_task_id,
      start_at: task_started_at,
      end_at:   Time.now
    )

    save
  end
end
