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
end
