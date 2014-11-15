load 'backtrack.rb'

namespace :run_backtrack do
    desc "run backtrack for tmrw"
    task :start => :environment do
        puts '%%%%%%%'

        matches = backtrackTomorrow
        seeAllMatches(matches)
        # testEmail
        sendEmails(matches)
        createLunches(matches)
    end
end

def backtrackTomorrow
    tmrw = DateTime.tomorrow  #heree careful with fri

    usersTmrw = filterUsers( User.all, tmrw )
    puts usersTmrw.count

    pairsPossible = createPairs( usersTmrw, tmrw )
    puts pairsPossible.count

    bestN = usersTmrw.count / 2
    pairsPossible.shuffle! # add randomness before backtrack
    pairsFinal = backtrack(pairsPossible, [], [], bestN)

    matchesFinal = addRandomOpening(pairsFinal, tmrw)

    return matchesFinal
end

# matches is an array of matches each of form [user1, user2, opening]
def sendEmails(matches)
    matches.each do |match|
        UserMailer.match_email(match).deliver
    end
end

def testEmail
    UserMailer.match_email([User.find(1), User.find(1), Opening.first]).deliver
end

def seeAllMatches(matches)
    matches.each do |match|
        puts "////"
        puts match[0].email + "   " + match[1].email
        print match[2].date_time
        puts match[2].place
    end
    return nil
end

# matches are of form [user1, user2, opening]
def createLunches(matches)
    matches.each do |match|
            lunch = Lunch.create(place: match[2].place, time: match[2].date_time)

            # can associate 1 lunch with 2 users because of join table
            # can view the two associations with Match.all
            match[0].lunches << lunch # store lunch in user1 data
            match[1].lunches << lunch # store lunch in user2 data
    end
end
