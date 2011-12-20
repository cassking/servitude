require 'spec_helper'

describe TimersController do
  before(:each) { controller.login(mock(id: 1234)) }

  describe 'GET show' do
    let!(:tasks) do
      [mock, mock].tap do |tasks|
        Task.stub(all: tasks)
      end
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
    let(:task_id) { '123' }

    before(:each) { controller.current_user.stub(:start_task) }

    it 'starts the task for the #current_user' do
      controller.current_user.should_receive(:start_task).with(task_id)
      post :start_task, task_id: task_id
    end

    it 'redirects to tasks_path' do
      post :start_task, task_id: task_id
      response.should redirect_to(timer_path)
    end
  end
end
