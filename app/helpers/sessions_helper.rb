module SessionsHelper
	def log_in(user)
		# временные куки шифруются, а постоянные, созданные методом cookies не шифруютс сами по себе
		session[:user_id] = user.id
end
