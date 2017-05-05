json.id @comment.id
json.message @comment.message
json.author @comment.user.full_name
json.authorImageUrl @comment.user.avatar_url
json.canEdit can_edit?(@comment)
json.createdAtDate @comment.created_at.strftime("%d.%m.%y")
json.createdAtTime @comment.created_at.strftime("%H:%M")
json.isResponse @comment.user == @comment.post.user ? true : false
