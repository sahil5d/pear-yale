namespace :db do
  desc "fill database with sample data"
  task populate: :environment do
    # makeUsers
  end
end

# def makeUsers
#   create fake users, with fake openings
#   use 'faker' gem
#   admin = User.create!(fname: "Adminnn",
#                        email: "admin@yale.edu",
#                        admin: true)
# end

# def makeOpening
#   make fake openings
#   return opening
# end
