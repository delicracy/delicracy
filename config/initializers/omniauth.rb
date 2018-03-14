OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets.facebook_id, Rails.application.secrets.facebook_key
  provider :kakao, Rails.application.secrets.kakao_key, Rails.application.secrets.kakao_secret, redirect_path: '/auth/kakao/callback'
end
