require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  it 'redirect to sign_in if not authenticated' do
    get 'index'
    response.should redirect_to '/users/sign_in'
  end

  describe 'Login with an admin user' do
    login_admin_user
    it 'show a list of user' do
      FactoryGirl.create(:user)
      assigns(:users).should_not nil
    end
  end

  describe 'Login with a standard user' do
    login_user
    it 'show a list of invoices and tickets in case of normal user'
  end
end