class Opening < ActiveRecord::Base
	belongs_to :user

	@@times = [660, 690, 720, 750, 780, 810, 840, 870]

	@@timenames = ['11:00 - 11:30', '11:30 - 12:00', '12:00 - 12:30',
					'12:30 - 1:00', '1:00 - 1:30'  , '1:30 - 2:00',
					'2:00 - 2:30'  , '2:30 - 3:00']; # 8 total

	@@places = ['morse','stiles','commons','silliman','td',
					'trumbull','berkeley','calhoun','saybrook',
					'pierson', 'davenport', 'branford','je']

	# @@placesHash = {'mc'=>'morse','es'=>'stiles','cm'=>'commons','td'=>'td',
	# 			  'sc'=>'silliman','tc'=>'trumbull','je'=>'je','cc'=>'calhoun',
	# 			  'pc'=>'pierson','bk'=>'berkeley', 'dc'=>'davenport',
	# 			  'sy'=>'saybrook','br'=>'branford'}

	def self.gettimes
		star = @@timenames.dup
		star[0] += '*'; star[5] += '*'; star[6] += '*'; star[7] += '*'
		return star
	end

	def self.getplaces
		@@places
	end

	# calculate actual datetime of scheduled opening
	def addDatetime
		dt = Opening.nextdatetime(nil) # fixed, used to be DateTime.now
		dt += 1 while dt.wday != self.weekday
		dt = dt.midnight + self.minuteTime.minutes

		self.date_time = dt
		self.save
	end

	# pass in all user's openings
	# return string array of ids to be clicked "#d_p_,#d_t_,...""
	def self.existingopenings(useropenings)
		useropenings = useropenings.where("date_time > ?",
											Opening.nextdatetime(nil))
		list = []
		useropenings.each do |o|
			day = "#d" + o.weekday.to_s
			list << day + "p" + @@places.index(o.place).to_s
			list << day + "t" + @@times.index(o.minuteTime).to_s
		end
		list.uniq.join(',')
	end

	# pass in all user's openings
	# return clean array of [[when, where], [when, where]...] for mon-fri
	def self.existingopeningsclean(useropenings)
		useropenings = useropenings.where("date_time > ?",
				Opening.nextdatetime(nil))

		list = [[],[],[],[],[]]
		useropenings.each do |o|
			list[o.weekday - 1] << [ @@timenames[ @@times.index(o.minuteTime) ],
																o.place ]
		end

		# rotate array so that first available day is up first
		shift = Opening.nextday - 1
		return list.rotate(shift)
	end

	# return first next day signup allowed, cutoff at 7pm
	# pass in aaj which is "today", if nil then use DateTime.now
	# but as a datetime
	def self.nextdatetime(aaj)
		today = (aaj || DateTime.now)
		tmrw = today + ((today.hour < 19) ? 1 : 2)
		if tmrw.wday==0
			tmrw += 1
		elsif tmrw.wday==6
			tmrw += 2
		end
		return tmrw.midnight
	end

	def self.next5datetimes
		datetimes = [nextdatetime(nil)]
		4.times do
			datetimes << nextdatetime( datetimes[-1] )
		end
		return datetimes
	end

	# return self.nextdatetime converted to day
	# 1 monday, 5 friday
	def self.nextday
		nextdatetime(nil).wday
	end

	# returns next 5 free days as numbers
	def self.next5days
		return next5datetimes.map { |d| d.wday }
	end

	# returns next 5 free days as "mon 11/8"
	def self.next5names
		return next5datetimes.map { |d| d.strftime("%a %-m/%-d") }
	end

	# get array like
	# weekplaces = [p1, p2, p3, p4, p5]
	# weektimes  = [t1, t2, t3, t4, t5]
	def self.createAll(weekplaces, weektimes, current_user)
		weekplaces.each_with_index do |dayplaces, day|
			dayplaces.each do |placeId|
				placeId = placeId.to_i
				
				next if !(theplace = @@places[placeId]) # if out of bounds

				weektimes[day].each do |timeId|
					timeId = timeId.to_i

					# ensure t0,t5,t6,t7 only at commons=p2
					next if [0,5,6,7].index(timeId) && placeId!=2

					next if !(thetime = @@times[timeId]) # if out of bounds

					if Opening.where("date_time > ?",
										Opening.nextdatetime(nil)).where(
										place: theplace,
										minuteTime: thetime,
										weekday: (day + 1),
										user_id: current_user.id ).length > 0
						next
					end

					o = Opening.create(
							place: theplace,
							minuteTime: thetime,
							weekday: (day + 1),
							user_id: current_user.id)
					o.addDatetime
					o.save
				end
			end
		end
	end #end createAll

end
