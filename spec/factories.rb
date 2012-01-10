Factory.define :user do |user|
  user.alias "ROBMAN"
  user.email "ROB@MAN.JP"
  user.password "FOOBAR"
  user.password_confirmation "FOOBAR"
end

Factory.sequence :alias do |n|
  "ROBMAN-#{n}"
end

Factory.sequence :email do |n|
  "ROB-#{n}@MAN.JP"
end

Factory.define :conference do |conference|
  conference.title "MUN CONF"
  conference.association :user, :alias => "ADMINMAN", :email => "ADMIN@MAN.JP",
                                :admin => true
  conference.date "END OF TIMES"
  conference.location "HELL"
end

Factory.sequence :title do |n|
  "DIABOLIC CONF #{n}"
end
