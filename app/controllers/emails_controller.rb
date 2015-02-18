class EmailsController < ApplicationController
	def new
		@email = Email.new
	end

	def create
		@email = Email.new(email_params)
		if @email.save
			@email.send_confirmation
			flash[:info] = "Please check your email to activate your account."
			redirect_to root_url, notice: "Thank you, we sent you a confirmation email!"
		else
			render 'new'
		end
	end

	private

	def email_params
		params.require(:email).permit(:email)
	end

	def account_confirmation	
		@email = Email.find_by_email_confirm_token(params[:token])
		if(@email)
			@email.update_column(:activated, true)
			@email.update_column(:email_confirm_token, nil)
			redirect_to login_url, :notice => "Account confirmed"
		else
			redirect_to login_url, :notice => "Account could not be confirmed"
		end
	end
end
