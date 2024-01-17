module SessionsHelper
	def log_in(user)
		# временные куки шифруются, а постоянные, созданные методом cookies не шифруютс сами по себе
		session[:user_id] = user.id
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	def remember(user)
    user.remember_me
    cookies.encrypted.permanent[:remember_token] = user.remember_token
		cookies.encrypted.permanent[:user_id] = user.id
  end

	def forget(user)
		user.forget_me
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def current_user
		if session[:user_id].present?
			@current_user ||= User.find_by(id: session[:user_id])
		elsif cookies.encrypted[:user_id].present?
			user = User.find_by(id: cookies.encrypted[:user_id])
			if user && user.authenticated?(cookies.encrypted[:remember_token])
				log_in(user)
				@current_user ||= user
			end
		end
	end

	def logged_in?
		!current_user.nil?
	end

	def current_user?(user)
		user == current_user
	end

	# Перенаправляет к сохраненному расположению (или по умолчанию).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Сохраняет запрошенный URL.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
