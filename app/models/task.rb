class Task
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
end
