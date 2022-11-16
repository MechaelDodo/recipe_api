require 'rails_helper'

RSpec.describe "Carts", type: :request do
  describe "POST /carts" do
    it "add friend and check cart for test Friendship" do
      user = FactoryBot.create(:user)
      token = ApplicationController.new.encode_token(user_id: user.id)
      cart = Cart.create(user:user)
      CartIngredient.create(cart:cart, ingredient:FactoryBot.create(:ingredient), user_id:user.id)
      user2 = FactoryBot.create(:user)
      token2 = ApplicationController.new.encode_token(user_id: user.id)
      post "/add_friend/",:params => {friend_id: user2.id }, headers:{"Authorization":"Bearer "+token}, xhr: true
      CartIngredient.create(cart:cart, ingredient:FactoryBot.create(:ingredient), user_id:user2.id)
      get "/carts/#{user.id}", headers:{"Authorization":"Bearer "+token2}, xhr: true
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["ingredients"].size).to eq(2)
    end
  end
end
