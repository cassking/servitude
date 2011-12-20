require 'spec_helper'

describe User do
  subject { create_user }

  describe '.get_authenticated' do
    it 'returns a user with a valid email and password combination' do
      subject.should == User.get_authenticated(subject.email, 'a_password')
    end

    it 'returns nil with an invalid email and password combination' do
      User.get_authenticated('user@weblinc.com', 'an_incorrect_password').should be_nil
    end

    it "returns nil if the email address doesn't exist" do
      User.get_authenticated('non_existing@weblinc.com', 'a_password').should be_nil
    end
  end

  describe '#authenticate?' do
    it 'returns true with a correct password' do
      subject.authenticate?('a_password').should be_true
    end

    it 'returns false with an incorrect password' do
      subject.authenticate?('an_incorrect_password').should be_false
    end
  end

  describe 'validations' do
    it 'validates uniqueness of email address' do
      create_user email: 'user@weblinc.com'
      invalid_user = create_user email: 'user@weblinc.com'

      invalid_user.should_not be_valid
      invalid_user.errors[:email].should_not be_empty
    end
  end

  describe '#start_task' do
    let(:user) { create_user }
    let(:task) { create_task }

    before(:each) { Time.stub(now: '15/11/2011'.to_datetime) }
    before(:each) { user.start_task(task.id) }

    context 'when there is no running task' do
      it 'sets current task to the task' do
        user.current_task.should == task
      end

      it 'sets the time the current task started' do
        user.task_started_at.should == '15/11/2011'.to_datetime
      end
    end

    context 'when a task is already started' do
      let(:currently_running_task) { create_task }
      let(:started_at) { '15/11/2011'.to_datetime }
      let(:user) do
        create_user(
          current_task_id: currently_running_task.id,
          task_started_at: started_at
        )
      end

      describe 'the created time entry' do
        subject { user.time_entries.last }

        its(:task_id) { should == currently_running_task.id }
        its(:start_at) { should == started_at }
      end
    end

    context 'when the same task is already running' do
      before(:all) do
        @currently_running_task = create_task
      end

      let(:started_at) { '15/11/2011'.to_datetime }
      let(:user) do
        create_user(
          current_task_id: @currently_running_task.id,
          task_started_at: started_at
        )
      end

      it 'does not create a new time entry' do
        currently_running_task = create_task

        user = create_user(
          current_task_id: currently_running_task.id,
          task_started_at: started_at
        )

        expect do
          user.start_task(currently_running_task.id)
        end.to_not change { user.time_entries.length }
      end

      it 'does not call #stop_task' do
        currently_running_task = create_task

        user = create_user(
          current_task_id: currently_running_task.id,
          task_started_at: started_at
        )

        user.should_not_receive(:stop_task)
        user.start_task(currently_running_task.id)
      end
    end
  end

  describe '#stop_task' do
    let(:task) { create_task }
    let(:started_at) { '15/11/2011'.to_datetime }
    let(:user) { create_user(task_started_at: started_at, current_task: task) }

    before(:each) { user.stop_task }

    it 'sets the current task to nil' do
      user.current_task.should be_nil
    end

    it 'sets the #task_started_at to nil' do
      user.task_started_at.should be_nil
    end

    describe 'resulting TimeEntry' do
      subject { TimeEntry.first(conditions: { user_id: user.id }) }

      its(:task_id) { should == task.id }
      its(:start_at) { should == started_at }
    end
  end
end
