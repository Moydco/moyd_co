require 'rails_helper'

RSpec.describe StaticsController, type: :controller do

  describe 'GET #infrastructure' do
    it 'returns infrastructure page' do
      get :infrastructure
      response.should render_template :infrastructure
    end
  end

  describe 'GET #dns' do
    it 'returns dns page' do
      get :dns
      response.should render_template :dns
    end
  end

  describe 'GET #support' do
    it 'returns support page' do
      get :support
      response.should render_template :support
    end
  end

  describe 'GET #team' do
    it 'returns team page' do
      get :team
      response.should render_template :team
    end
  end

  describe 'GET #contact_us' do
    it 'returns contact_us page' do
      get :contact_us
      response.should render_template :contact_us
    end
  end

  describe 'POST #create' do
    it 'render contact_us with an error in case of missing parameter' do
      post :create
      response.should render_template :contact_us
    end

    describe 'opt_in = true' do
      it 'send a message' do
        post :create, user: FactoryGirl.attributes_for(:user)
        response.should render_template 'subscribe_mailer/new_subscription'
      end

      it 'create an user' do
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change(User,:count).by(1)
      end

      it 'render contact_us with an error in case of missing parameter' do
        post :create, user: FactoryGirl.attributes_for(:invalid_user)
        response.should render_template :contact_us
      end
    end

    describe 'opt_in = false' do
      it 'render root path' do
        post :create, user: FactoryGirl.attributes_for(:user_no_opt_in)
        response.should render_template 'subscribe_mailer/new_message'
      end
    end
  end
end