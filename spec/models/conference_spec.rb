require 'spec_helper'

describe Conference do

  before(:each) do
    @admin = Factory(:user, :alias => "ADMINMAN", :email => "ADMIN@MAN.JP",
                           :admin => true)
    @attr = {
      :title => "MUN CONFERENCE OF DOOM!",
      :time => "END OF TIMES!",
      :location => "HELL!"
    }
  end

  it "should create a new instance given valid attributes" do
    @admin.conferences.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @conference = @admin.conferences.create(@attr)
    end

    it "should have a user attribute" do
      @conference.should respond_to(:user)
    end

    it "should have the right associated user" do
      @conference.user_id.should == @admin.id
      @conference.user.should == @admin
    end
  end

  describe "validations" do

    it "should require a user id" do
      Conference.new(@attr).should_not be_valid
    end

    it "should require nonblank title" do
      @admin.conferences.build(:title => " ").should_not be_valid
    end

    it "should reject a long title" do
      @admin.conferences.build(:title => "a" * 65).should_not be_valid
    end
  end

  describe "attendances" do

    before(:each) do
      @user = Factory(:user)
      @conference = @admin.conferences.create!(@attr)
    end

    it "should have an attendances method" do
      @conference.should respond_to(:attendances)
    end

    it "should have an attendees method" do
      @conference.should respond_to(:attendees)
    end

    it "should include an attendee in the attendees array" do
      @user.attend!(@conference)
      @conference.attendees.should include(@user)
    end
  end
end
