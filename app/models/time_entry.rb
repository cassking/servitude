class TimeEntry
  include DataMapper::Resource

  property :id, Serial
  property :start_at, DateTime
  property :end_at, DateTime

  belongs_to :user
  belongs_to :task
end
