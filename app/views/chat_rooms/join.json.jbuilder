json.result "ok"
json.joinId @user._id.to_s
json.joinName @user.name
json.joinThumb URI.join(MY_APP[:pm_domain], @user.avatar_url).to_s
