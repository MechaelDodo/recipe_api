require 'rails_helper'

RSpec.describe Recipe, type: :request do
  describe "GET /recipes" do
    it "check count of ingredients in one recipe" do
      user = FactoryBot.create(:user)
      token = ApplicationController.new.encode_token(user_id: user.id)
      recipe = FactoryBot.create(:recipe, user: user)

      recipe.ingredients << FactoryBot.create(:ingredient)
      recipe.ingredients << FactoryBot.create(:ingredient)
      recipe.ingredients << FactoryBot.create(:ingredient)
      get "/recipes/#{recipe.id}", headers:{"Authorization":"Bearer "+token}, xhr: true#, request.formats=> ["application/json"]
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["ingredients"].size).to eq(3)
    end
  end
end
