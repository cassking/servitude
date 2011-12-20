require 'spec_helper'

describe TimeEntry do
  let(:user) { create_user }
  let(:task) { create_task }

  it 'can be created' do
    create_time_entry(user: user, task: task)
  end
end
