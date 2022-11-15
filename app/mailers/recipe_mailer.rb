# frozen_string_literal: true

# mailer after creating the first recipe
class RecipeMailer < ApplicationMailer
  def recipe_created
    @user = params[:user]
    @recipe = params[:recipe]

    mail(
      to: @user.email,
      subject: 'The first recipe was created!'
    )
  end
end
