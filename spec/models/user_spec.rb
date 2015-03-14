require 'rails_helper'

describe User do
  it 'has a valid factory' do
    FactoryGirl.create(:user).should be_valid
  end
  it 'is invalid without an email' do
    FactoryGirl.build(:user, email: nil).should_not be_valid
  end
  it 'is invalid without a first name' do
    FactoryGirl.build(:user, first_name: nil).should_not be_valid
  end
  it 'is invalid without a last name' do
    FactoryGirl.build(:user, last_name: nil).should_not be_valid
  end
  it 'does not allow duplicate email' do
    FactoryGirl.create(:user, email: 'test@email.tld' )
    FactoryGirl.build(:user, email: 'test@email.tld' ).should_not be_valid
  end
  it 'have a valid password' do
    user = FactoryGirl.create(:user)
    user.encrypted_password.should_not be_empty
  end
end