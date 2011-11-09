require 'spec_helper'

describe LoginsController do
  describe 'GET' do
    it 'renders the login form' do
      get :show
      response.should render_template('logins/show')
    end
  end
  
  describe 'POST create' do
    context 'valid params' do
      let(:user) { mock(id: 12345) }
      before(:each) { User.stub(get_authenticated: user) }

      it 'logs the user in' do
        post :create, email: 'user@weblinc.com', password: 'password'
        session[:user_id].should == user.id
      end

      it 'redirects to timers controller' do
        post :create, email: 'user@weblinc.com', password: 'password'
        response.should redirect_to(timer_path)
      end
    end
    
    context 'invalid params' do
      before(:each) { User.stub(get_authenticated: nil) }

      it 'renders the login form' do
        post :create, email: 'user@weblinc.com', password: 'password'
        response.should render_template('logins/show')        
      end
      
      it 'sets an error message' do
        post :create, email: 'user@weblinc.com', password: 'password'
        flash[:error].should_not be_blank
      end
    end
  end
end
