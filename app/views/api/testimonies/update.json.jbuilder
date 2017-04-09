json.id @testimony.id
json.message @testimony.message
json.author @testimony.user.full_name
json.canEdit can_edit?(@testimony)
