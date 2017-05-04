json.message @post.message
json.id @post.id
json.message @post.message
json.author @post.user.full_name
json.authorImageUrl @post.user.avatar_url
json.createdAtDate @post.created_at.strftime("%d.%m.%y")
json.createdAtTime @post.created_at.strftime("%H:%M")
if @post.image
  json.imageUrl @post.image.file.m.url
end
json.comments @comments do |comment|
  json.id comment.id
  json.message comment.message
  json.author comment.user.full_name
  json.authorImageUrl comment.user.avatar_url
  json.canEdit can_edit?(comment)
  json.createdAtDate comment.created_at.strftime("%d.%m.%y")
  json.createdAtTime comment.created_at.strftime("%H:%M")
  json.isResponse comment.user == @post.user ? true : false
end