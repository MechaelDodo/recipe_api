class CreateFirstNotificationJob < ApplicationJob
  queue_as :default


  def perform(args)
    # Do something later
    RecipeMailer.with(user: args[:user], recipe: args[:recipe]).recipe_created.deliver_now
  end
end
