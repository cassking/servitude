require 'spec_helper'

describe ApplicationController do
  let(:user) { mock(id: 1234) }

  describe '#current_user' do
    before(:each) { session[:user_id] = 1234 }

    it 'is the user from the session' do
      User.should_receive(:get).with(1234).and_return(user)
      controller.current_user.should == user
    end
  end

  describe '#login' do
    before(:each) { controller.login(user) }

    it 'sets the #current_user equal to the user passed' do
      controller.current_user.should == user
    end

    it 'sets the session[:user_id]' do
      session[:user_id].should == 1234
    end
  end

  describe '#logout' do
    before(:each) do
      controller.login(user)
      controller.logout
    end

    it 'clears the current user' do
      controller.current_user.should be_blank
    end

    it "deletes the user's session id" do
      session[:user_id].should be_blank
    end
  end

  describe '#ensure_logged_in' do
    controller do
      def index
        head :ok
      end
    end

    context 'not logged in' do
      it 'redirects to the login page' do
        get :index
        response.should redirect_to(login_path)
      end
    end

    context 'logged in' do
      before(:each) { controller.login(user) }

      it 'allows the request' do
        get :index
        response.should be_ok
      end
    end
  end
end
