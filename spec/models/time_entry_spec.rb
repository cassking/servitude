require 'spec_helper'

describe TimeEntry do
  let(:user) { create_user }
  let(:task) { create_task }

  it 'can be created' do
    create_time_entry(user: user, task: task)
  end

  describe '.current_task_for' do
    context 'when no open time entry for the user' do
      it 'returns nil' do
        TimeEntry.current_task_for(user.id).should be_nil
      end
    end

    context 'when open time entry for the user' do
      let!(:open_time_entry) { create_time_entry(user: user, task: task) }
      let!(:closed_time_entry) do
        create_time_entry(
          user: user,
          task: create_task,
          start_at: 10.minutes.ago,
          end_at: 5.minutes.ago
        )
      end

      it 'returns the open time entry' do
        TimeEntry.current_task_for(user.id).should == open_time_entry.task
      end
    end
  end

  describe '.start_task' do
    it 'creates a new time entry' do
      expect do
        TimeEntry.start_task(user.id, task.id)
      end.to change { TimeEntry.count }.by(1)
    end

    describe ' the created time entry' do
      subject { TimeEntry.start_task(user.id, task.id) }

      its(:user_id)  { should == user.id }
      its(:task_id)  { should == task.id }
      its(:start_at) { should_not be_nil }
    end
  end

  describe '.stop_task' do
    before { TimeEntry.start_task(user.id, task.id) }

    it 'ends the time entry' do
      TimeEntry.stop_task(user.id)
      TimeEntry.last_for(user.id).end_at.should_not be_nil
    end

    it 'clears the open task' do
      expect do
        TimeEntry.stop_task(user.id)
      end.to change { TimeEntry.current_task_for(user.id) }.to(nil)
    end
  end

  describe '.recent_for' do
    let(:time_entries) do
      [ TimeEntry.create(user: user, task: task),
        TimeEntry.create(user: user, task: task),
        TimeEntry.create(user: user, task: task) ]
    end

    it 'returns recent time entries for the user' do
      TimeEntry.recent_for(user.id).should == time_entries
    end
  end
end
