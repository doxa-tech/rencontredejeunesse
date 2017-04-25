json.id @comment.id
json.message @comment.message
json.author @comment.user.full_name
json.canEdit can_edit?(@comment)
json.createdAtDate @comment.created_at.strftime("%d.%m.%y")
json.createdAtTime @comment.created_at.strftime("%H:%M")
