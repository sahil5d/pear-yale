class ApplicationController < ActionController::Base
	# prevent csrf attacks by raising an exception.
	
	# get user by CAS login
	before_filter CASClient::Frameworks::Rails::Filter, :unless => :skip_login?
	before_filter :getMe

	protect_from_forgery with: :exception

	def current_user
		@me ||= User.find_by(netid: session[:cas_user])
	end

protected
		
	def getMe
		action = params[:action]
		return true if action=='home'

		# assert: ((cas login good) & (not in cookies)) | (skip cas & in cooki)
		return true if @me

		# assert: (cas login good) & (not in cookies)
		batman = session[:cas_user]					# given by first filter
		@me = User.find_by(netid: batman)			# find if netid in database
		if @me
			cookies.permanent.signed[:cas_user] = batman # save in cookie
			return redirectClean(action)
		end

		# assert: (cas login good) & (not in cookies|database)
		@me = User.create(netid: batman) 			# create
		if @me.addInfo 								# pulls data from csv
			@me = User.find_by(netid: batman) 		# reassign with new data
			cookies.permanent.signed[:cas_user] = batman # save in cookie
			return redirectClean(action)
		else										# assert: not in csv
			User.where(netid: batman).destroy_all
			@me = nil
			return redirect_to :root
		end
	end

	# prevent ugly cas parameter from showing up in url
	def redirectClean(action)
		if action=='show'; 		return redirect_to '/profile'
		elsif action=='new'; 	return redirect_to '/planner'
		elsif action=='index'; 	return redirect_to '/openings'
		elsif action=='finish'; return redirect_to '/finish'
		end
		return true
	end

	# hack for skip_before_filter with CAS
	# overwrite this method (with 'true') in any controller to skip CAS authen
	def skip_login?
		return true if @me 							# avoid repttv cooki writes

		if (batman = cookies.signed[:cas_user])		# if in cookies
			session[:cas_user] = batman				# copy to session
			@me = User.find_by(netid: batman)		# verify if real
			return true if @me
		end
		return false								# not in cookies | bad user
	end
end
