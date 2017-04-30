json.rememberToken @user.remember_token
json.firstname @user.firstname
json.lastname @user.lastname
json.email @user.email
json.imageUrl @user.image.file.avatar.url
json.isAdmin @user.belongs_to?(:leaders)
json.isSignedIn true
