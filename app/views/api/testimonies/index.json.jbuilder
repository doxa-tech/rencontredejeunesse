json.array! @testimonies do |testimony|
  json.id testimony.id
  json.message testimony.message
  json.author testimony.user.full_name
  json.authorImageUrl testimony.user.avatar_url
  json.canEdit can_edit?(testimony)
  json.createdAtDate testimony.created_at.strftime("%d.%m.%y")
  json.createdAtTime testimony.created_at.strftime("%H:%M")
end
