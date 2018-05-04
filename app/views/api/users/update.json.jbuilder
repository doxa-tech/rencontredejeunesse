json.rememberToken @user.remember_token
json.firstname @user.firstname
json.lastname @user.lastname
json.email @user.email
json.imageUrl @user.avatar_url
json.isAdmin @user.belongs_to?(:communication)
json.isSignedIn true
