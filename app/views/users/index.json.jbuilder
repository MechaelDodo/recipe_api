# frozen_string_literal: true

json.array! @users.each do |user|
  json.id user.id
  json.username user.username
  json.email user.email
end
