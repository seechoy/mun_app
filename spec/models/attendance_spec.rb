require 'spec_helper'

describe Attendance do

  before(:each) do
    @conference = Factory(:conference)
    @user = Factory(:user)

    @attendance = @user.attendances.build(:conference_id => @conference.id)
  end

  it "should create a new instance given valid attributes" do
    @attendance.save!
  end

  describe "attendance methods" do

    before(:each) do
      @attendance.save
    end

    it "should have a user attendee attribute" do
      @attendance.should respond_to(:user)
    end

    it "should have the right user attendee" do
      @attendance.user.should == @user
    end

    it "should have an attended conference attribute" do
      @attendance.should respond_to(:conference)
    end

    it "should have the right attended conference" do
      @attendance.conference.should == @conference
    end
  end

  describe "validations" do

    it "should require a user_id" do
      @attendance.user_id = nil
      @attendance.should_not be_valid
    end

    it "should require a conference_id" do 
      @attendance.conference_id = nil
      @attendance.should_not be_valid
    end
  end
end
