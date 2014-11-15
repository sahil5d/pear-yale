class StaticPagesController < ApplicationController

	def home
		@nUser = User.all.count
		# @nMatch = Match.all.count

		# http caching, two options, choose one
		# may turn off bc when login and go back to home, have to hard refresh
		fresh_when last_modified: User.all.maximum(:updated_at) # condtn based
		# expires_in 60.seconds, public: true # time based
	end

	def skip_login?
		true
	end

end
