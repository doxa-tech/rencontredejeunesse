json.rememberToken @user.remember_token
json.firstname @user.firstname
json.lastname @user.lastname
json.email @user.email
json.isAdmin @user.belongs_to?(:leaders)
json.isSignedIn true
