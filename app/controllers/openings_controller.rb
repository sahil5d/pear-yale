class OpeningsController < ApplicationController
	
	@@placesprints = ['west', 'north', 'mid', 'south']
	@@placesidprints = [0, 2, 5, 9]

	def new
		@user = current_user
		
		#to highlight existing openings
		@eo = Opening.existingopenings(@user.openings)

		@next5days = Opening.next5days
		@next5names = Opening.next5names
		
		@timenames = Opening.gettimes
		@placenames = Opening.getplaces

		@placesnames = @@placesprints
		@placesids = @@placesidprints
	end

	def create
		# flush future openings
		# expensive yes, but simple
		Opening.where(user_id: current_user.id).where(
						"date_time > ?", Opening.nextdatetime(nil)).destroy_all

		p1 = (params[:d1p] ||= []) #monday places
		p2 = (params[:d2p] ||= [])
		p3 = (params[:d3p] ||= [])
		p4 = (params[:d4p] ||= [])
		p5 = (params[:d5p] ||= [])

		t1 = (params[:d1t] ||= []) #monday times
		t2 = (params[:d2t] ||= [])
		t3 = (params[:d3t] ||= [])
		t4 = (params[:d4t] ||= [])
		t5 = (params[:d5t] ||= [])

		weekplaces = [p1, p2, p3, p4, p5]
		weektimes  = [t1, t2, t3, t4, t5]

		# create openings from scratch
		Opening.createAll(weekplaces, weektimes, current_user)

		redirect_to action: 'index'
	end

	def index
		@user = current_user
		@eoc = Opening.existingopeningsclean(@user.openings)

		# @next5days = Opening.next5days
		@next5names = Opening.next5names
	end

end
