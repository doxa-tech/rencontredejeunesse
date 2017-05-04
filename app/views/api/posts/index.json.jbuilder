json.array! @posts do |post|
  json.id post.id
  json.message post.message
  json.author post.user.full_name
  json.authorImageUrl post.user.avatar_url
  json.canEdit can_edit?(post)
  json.createdAtDate post.created_at.strftime("%d.%m.%y")
  json.createdAtTime post.created_at.strftime("%H:%M")
  if post.image
    json.imageUrl post.image.file.m.url
  else
    json.imageUrl nil
  end
  json.lastComment do
    if post.last_comment
      json.message post.last_comment.message
      json.author post.last_comment.user.full_name
    else
      json.nil!
    end
  end
end
