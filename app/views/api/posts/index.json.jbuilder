json.array! @posts do |post|
  json.id post.id
  json.message post.message
  json.author post.user.full_name
  json.lastComment do
    if post.last_comment
      json.message post.last_comment.message
      json.author post.last_comment.user.full_name
    else
      json.nil!
    end
  end
end
