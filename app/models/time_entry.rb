class TimeEntry
  include DataMapper::Resource

  property :id, Serial
  property :start_at, DateTime
  property :end_at, DateTime

  belongs_to :user
  belongs_to :task

  def self.current_task_for(user_id)
    open_time_entry = open_for(user_id)

    if open_time_entry.present?
      open_time_entry.task
    else
      nil
    end
  end

  def self.last_for(user_id)
    all(user_id: user_id).last
  end

  def self.open_for(user_id)
    all(user_id: user_id, end_at: nil).first
  end

  def self.recent_for(user_id)
    all(user_id: user_id, limit: 10, order: :end_at.desc)
  end

  def self.start_task(user_id, task_id)
    TimeEntry.create(
      user_id:  user_id,
      task_id:  task_id,
      start_at: Time.now
    )
  end

  def self.stop_task(user_id)
    time_entry = TimeEntry.open_for(user_id)
    time_entry.end_at = Time.now
    time_entry.save
  end
end
