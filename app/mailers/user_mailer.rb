class UserMailer < ActionMailer::Base
	default from: "pear.yale@gmail.com"

	# match input is of form [user1, user2, opening]
	def match_email(match)
		@user1 = match[0]
		@user2= match[1]
		@opening = match[2]
		
		mail(to: 'pear.yale@gmail.com', cc: [@user1.email, @user2.email],
				subject: "you've been peared!")
	end

end
