json.result "ok"
json.joinid @user._id.to_s
json.joinName @user.name
json.joinThumb @user.avatar_url
