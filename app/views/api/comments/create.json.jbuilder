json.id @comment.id
json.message @comment.message
json.author @comment.user.full_name
json.canEdit can_edit?(@comment)
