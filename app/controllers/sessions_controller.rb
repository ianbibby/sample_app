class SessionsController < ApplicationController

	def new
		@user = User.new	
	end

	def create
		user = User.find_by_email(params[:email])
		if user && user.authenticate(params[:password])
			sign_in(user)
			redirect_to user # same as user_path(user)
		else
			flash.now[:error] = "Invalid email/password combination"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

end
