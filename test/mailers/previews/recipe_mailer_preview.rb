# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/recipe_mailer
class RecipeMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/recipe_mailer/recipe_created
  def recipe_created
    RecipeMailer.recipe_created
  end
end
