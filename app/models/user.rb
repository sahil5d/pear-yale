require "reader"

class User < ActiveRecord::Base
	has_many :openings
	has_many :matches
	has_many :lunches, through: :matches

	def name
		self.fname + " " + self.lname
	end

	# return true if student's netid found in csv, else nil
	def addInfo
		# get [netid,nickname,email,fname,lname,year,college]
		info = getStudent(self.netid)
	
		return nil if !info

		self.fname    = info[1]
		self.lname    = info[4]
		self.email    = info[2]
		self.year     = info[5]
		self.college  = info[6]
		self.save!
	end

end
