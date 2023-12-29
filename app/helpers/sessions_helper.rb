module SessionsHelper
	def log_in(user)
		# временные куки шифруются, а постоянные, созданные методом cookies не шифруютс сами по себе
		session[:user_id] = user.id
	end

	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end
end
