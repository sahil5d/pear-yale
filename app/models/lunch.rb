class Lunch < ActiveRecord::Base
	has_many :matches
	has_many :users, through: :matches # has two users in fact
end
