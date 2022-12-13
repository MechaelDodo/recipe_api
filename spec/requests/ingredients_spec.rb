require 'rails_helper'

def user_login(user)
  secret = Rails.application.secrets.json_web_token_secret
  encoding = 'HS512'
  get '/ingredients/', headers:{"Authorization":"Bearer "+(JWT.encode({ user_id: user.id }, secret, encoding))}
  #request.headers["Authorization"] =
  #  JWT.encode({ user_id: user.id }, secret, encoding)
end

RSpec.describe Ingredient, type: :request do

  let(:user) { users(:user) }
  describe "GET /ingredients" do
    it "check count of ingredients" do
      FactoryBot.create(:ingredient)
      FactoryBot.create(:ingredient)
      FactoryBot.create(:ingredient)
      user = FactoryBot.create(:user)
      token = ApplicationController.new.encode_token(user_id: user.id)
      get '/ingredients/', headers:{"Authorization":"Bearer "+token}
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end
