require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "USER NAME", :with => ""
          fill_in "EMAIL", :with => ""
          fill_in "PASSWORD", :with => ""
          fill_in "CONFIRMATION", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "USER NAME", :with => "EXAMPLE USER"
          fill_in "EMAIL", :with => "user@example.com"
          fill_in "PASSWORD", :with => "FOOBAR"
          fill_in "CONFIRMATION", :with => "FOOBAR"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "WELCOME")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in/out" do

    describe "failure" do

      it "should not sign a user in" do
        visit signin_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "INVALID")
      end
    end

    describe "success" do

      it "should sign a user in and out" do
        user = Factory(:user)
        visit signin_path
        fill_in :email, :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        click_link "SIGN OUT"
        controller.should_not be_signed_in
      end
    end
  end
end
