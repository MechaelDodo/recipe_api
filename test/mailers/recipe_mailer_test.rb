# frozen_string_literal: true

require 'test_helper'

class RecipeMailerTest < ActionMailer::TestCase
  test 'recipe_created' do
    mail = RecipeMailer.recipe_created
    assert_equal 'Recipe created', mail.subject
    assert_equal ['to@example.org'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Hi', mail.body.encoded
  end
end
