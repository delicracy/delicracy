module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  # return logged in user
  def current_user
    if session[:user_id]
      begin
        @current_user = User.find_by(id: session[:user_id]['$oid'])
      rescue Mongoid::Errors::DocumentNotFound => e
        log_out
      end
    end
    @current_user
  end

  def logged_in?
    not current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  # redirect to saved address
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def admin?(user=nil)
    user ||= current_user
    user&.is_admin
  end
end
