require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  context 'Create ingredient' do  # (almost) plain English
    it 'check amount' do
      FactoryBot.create(:ingredient)
      FactoryBot.create(:ingredient)
      FactoryBot.create(:ingredient)
      expect(Ingredient.all.count).to eq(3)
    end
  end
end
