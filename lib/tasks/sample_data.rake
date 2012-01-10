namespace :db do
  desc "FILL DATABASE WITH SAMPLE DATA"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_conferences
    make_attendances
  end
end

def make_users
  admin = User.create!(:alias => "ROBMAN",
                       :email => "ROB@MAN.JP",
                       :password => "FOOBAR",
                       :password_confirmation => "FOOBAR")
  admin.toggle!(:admin)
  99.times do |n|
    name = "ROBMINION-#{n}"
    email = "ROB-#{n}@MINION.JP"
    password = "PASSWORD"
    User.create!(:alias => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end
   
def make_conferences
  admin = User.first
  5.times do |n|
    title = "MUN CONFERENCE OF DOOM #{n+1}!!!"
    date = "END TIMES #{n+1}"
    location = "HELL #{n+1}"
    admin.conferences.create!(:title => title, :date => date, 
                              :location => location)
  end
end

def make_attendances
  users = User.all
  conferences = Conference.all
  bunchone = users[10..40]
  bunchtwo = users[20..50]
  bunchthree = users[30..60]
  bunchone.each { |attendee| attendee.attend!(conferences[1]) }
  bunchtwo.each { |attendee| attendee.attend!(conferences[2]) }
  bunchthree.each { |attendee| attendee.attend!(conferences[3]) }
end
