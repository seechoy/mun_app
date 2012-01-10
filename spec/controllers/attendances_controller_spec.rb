require 'spec_helper'

describe AttendancesController do

  describe "access control" do

    it "should require a signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should require a signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @conference = Factory(:conference)
    end

    it "should create an attendance" do
      lambda do
        post :create, :attendance => { :conference_id => @conference }
        response.should be_redirect
      end.should change(Attendance, :count).by(1)
    end

    it "should create an attendance using Ajax" do
      lambda do
        xhr :post, :create, :attendance => { :conference_id => @conference }
        response.should be_success
      end.should change(Attendance, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @conference = Factory(:conference)
      @user.attend!(@conference)
      @attendance = @user.attendances.find_by_conference_id(@conference)
    end

    it "should destroy an attendance" do
      lambda do
        delete :destroy, :id => @attendance
        response.should be_redirect
      end.should change(Attendance, :count).by(-1)
    end

    it "should destroy an attendance using Ajax" do
      lambda do
        xhr :delete, :destroy, :id => @attendance
        response.should be_success
      end.should change(Attendance, :count).by(-1)
    end
  end
end
