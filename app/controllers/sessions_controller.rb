class SessionsController < ApplicationController
  def new
  end

	def create
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password])
			log_in(user)
			remember(user) if params[:remember_me] == "1"
			redirect_back_or user
		else
			flash.now[:danger] = 'Invalid email/password combination'
			render :new
		end
	end

	def destroy
		log_out if logged_in?
		flash[:success] = "See your later!"
		redirect_to root_path
	end
end
