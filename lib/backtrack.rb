class Array
	# replace val with nil, return val and old index
	def xdelete(val)
		i = self.index(val)
		self[i] = nil
		[val, i]
	end
	# return length of array without nils
	def xlength
		i = 0
		self.each { |x| i+=1 if x!=nil }
		i
	end
	# 'a' is [val, index], insert val at index into array
	def xinsert(a)
		self[a[1]] = a[0]
	end
end

# will pass in User.all
# filter users with at least one opening on 'date'
def filterUsers(allUsers, date)
	filteredUsers = []
	allUsers.each do |user|
		if (user.openings.inject(false) {|result, o| result || (o.date_time.to_date == date)})
			filteredUsers << user
		end
	end

	filteredUsers
end

def createPairs(users, date)
	possibleMatches = []
	for i in (0...(users.length - 1))
		u1 = users[i]
		for j in ((i + 1)...users.length)
			u2 = users[j]
			(possibleMatches << [u1, u2]) if canMatch(u1, u2, date)
		end
	end
	return possibleMatches
end

# returns whether u1 u2 have at least one common opening
def canMatch(u1, u2, date)
	possibles = []

	u1o = u1.openings.where(date_time: date.beginning_of_day..date.end_of_day)
	u2o = u2.openings.where(date_time: date.beginning_of_day..date.end_of_day)

	u1o.each do |o1|
		u2o.each do |o2|
			return true if openingMinPlaceEq?(o1, o2)
		end
	end

	return false
end

def openingMinPlaceEq?(o1, o2)
	(o1.minuteTime == o2.minuteTime) && (o1.place == o2.place)
end

# input final pairs of people [[u1,u2], [u3,u4], ... ], date
# output same array with rand common opening appended to each pair
#     [[u1,u2,o1], [u3,u4,o2], ... ]
def addRandomOpening(pairsFinal, date)
	pairsFinal.length.times do |i|
		u1 = pairsFinal[i][0]
		u2 = pairsFinal[i][1]

		u1o = u1.openings.where(date_time: date.beginning_of_day..date.end_of_day)
		u2o = u2.openings.where(date_time: date.beginning_of_day..date.end_of_day)

		# common openings
		co = []
		u1o.each do |o1|
			u2o.each do |o2|
				if openingMinPlaceEq?(o1, o2)
					co << o1
					break
				end
			end
		end
	
		# random common opening
		rco = co.sample
		pairsFinal[i] << rco
	
	end
	return pairsFinal
end

# input
	# remaining possible matches
	# local branch matches
	# maximum matches so far
	# best possible number of matches
def backtrack (possibles, matches, maxMatches, bestN)
	# base case
	return matches if possibles.xlength == 0

	possibles.each_with_index do |possible, i|
		next if !possible

		# add possible match to the match array
		burp = possibles.xdelete(possible)
		matches << burp[0]
		deletedPossibles = [burp]

		# delete all possible matches that have same users as iterated possible
		# ignore possibilities before current index
		#    because search down tree need only look forward in possibles array
		possibles.each_with_index do |p, j|
			if (j<=i) || (p && (p.include?(possible[0]) || p.include?(possible[1])))
				deletedPossibles << possibles.xdelete(p)
			end
		end

		matchesRevert = matches.dup

		# if worth going down branch
		if (possibles.xlength + matches.length) > maxMatches.length
			# puts ">>>>>"
			# puts matches.inspect

			# recurse
			matches = backtrack(possibles, matches, maxMatches, bestN)

			# if new best solution
			if (matches.length > maxMatches.length) ||
					(matches.length == maxMatches.length && rand(2) == 0) # flip coin
				maxMatches = matches.dup
			end

			# if every possible match is made
			return maxMatches.dup if maxMatches.length == bestN

			matches = matchesRevert
		end

		# putting deleted elements back into possibles array
		matches.pop
		deletedPossibles.each do |d|
			possibles.xinsert(d)
		end
	end

	return maxMatches.dup
end
