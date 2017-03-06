json.array! @posts do |post|
  json.message post.message
  json.author post.user.full_name
end
