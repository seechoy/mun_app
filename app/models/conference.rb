class Conference < ActiveRecord::Base
  attr_accessible :title, :date, :location

  belongs_to :user

  has_many :attendances, :dependent => :destroy
  has_many :attendees, :through => :attendances, :source => :user

  validates :title, :presence => true, :length => { :maximum => 64 }
  validates :user_id, :presence => true

  self.per_page = 5
end
