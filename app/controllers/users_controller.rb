class UsersController < ApplicationController

	def show
		@user = current_user

		# @foods = ['quinoa', 'loaded oatmeal', 'squash medley', 'mushroom meat',
		#						'canadian bacon', 'tofu apple crisp']
	end

	def finish
		@user = current_user
	end

	def logout
		reset_session
		cookies.delete(:cas_user)
		redirect_to 'https://secure.its.yale.edu/cas/logout'
	end

end
