json.message @post.message
json.author @post.user.full_name
json.comments @comments do |comment|
  json.id comment.id
  json.message comment.message
  json.author comment.user.full_name
end
