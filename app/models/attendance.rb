class Attendance < ActiveRecord::Base
  attr_accessible :conference_id, :country

  belongs_to :user
  belongs_to :conference

  validates :user_id, :presence => true
  validates :conference_id, :presence => true
end
