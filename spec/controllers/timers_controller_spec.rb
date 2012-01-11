require 'spec_helper'

describe TimersController do
  before(:each) { controller.login(mock(id: 1234)) }

  describe 'GET show' do
    let!(:tasks) do
      [mock, mock].tap do |tasks|
        Task.stub(all: tasks)
      end
    end

    it 'sets the current task' do
      task = mock

      TimeEntry.
        should_receive(:current_task_for).
        with(1234).
        and_return(task)

      get :show
      assigns[:current_task].should == task
    end

    it 'sets recent entries for the user' do
      TimeEntry.
        should_receive(:recent_for).
        with(1234).
        and_return(tasks)

      get :show
      assigns[:recent_entries].should == tasks
    end

    it 'returns an OK status' do
      get :show
      response.should be_ok
    end

    it 'assigns a list of tasks' do
      get :show
      assigns[:tasks].should == tasks
    end
  end

  describe 'POST start_task'do
    let(:task_id) { '1234' }
    it 'starts the task for the #current_user' do
      TimeEntry.should_receive(:start_task).with(1234, '1234')
      post :start_task, task_id: task_id
    end

    it 'redirects to tasks_path' do
      post :start_task, task_id: task_id
      response.should redirect_to(timer_path)
    end
  end

  describe 'POST stop_task' do
    let(:task_id) { '1234' }

    it 'stops the task for the #current_user' do
      TimeEntry.should_receive(:stop_task).with(1234)
      post :stop_task
    end

    it 'redirects to tasks_path' do
      post :stop_task
      response.should redirect_to(timer_path)
    end
  end
end
