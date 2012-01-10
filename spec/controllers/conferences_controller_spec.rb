require 'spec_helper'

describe ConferencesController do
  render_views

  describe "access control" do

    describe "for non-signed in user" do

      it "should deny access to 'new'" do
        get :new
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'create'" do
        post :create
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'edit'" do
        get :edit, :id => 1
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => 1, :conference => {}
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'destroy'" do
        delete :destroy, :id => 1
        response.should redirect_to(signin_path)
      end
    end

    describe "for non-admin-user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
      end

      it "should bar access to 'new'" do
        get :new
        response.should redirect_to(root_path)
      end

      it "should bar access to 'create'" do
        post :create
        response.should redirect_to(root_path)
      end

      it "should bar access to 'edit'" do
        get :edit, :id => 1
        response.should redirect_to(root_path)
      end

      it "should bar access to 'update'" do
        put :update, :id => 1, :conference => {}
        response.should redirect_to(root_path)
      end

      it "should bar access to 'destroy'" do
        delete :destroy, :id => 1
        response.should redirect_to(root_path)
      end
    end
  end

  describe "authentication of edit/update/destroy pages" do

    before(:each) do
      @conference = Factory(:conference)
      wrong_admin = Factory(:user, :alias => "WRONGMAN",
                                   :email => "WRONG@MAN.JP", :admin => true)
      test_sign_in(wrong_admin)
    end

    it "should require matching associated users for 'edit'" do
      get :edit, :id => @conference
      response.should redirect_to(root_path)
    end

    it "should require matching associated users for 'update'" do
      put :update, :id => @conference, :conference => {}
      response.should redirect_to(root_path)
    end

    it "should require matching associated users for 'destroy'" do
      delete :destroy, :id => @conference
      response.should redirect_to(root_path)
    end
  end  

  describe "GET 'index'" do

    before(:each) do
      admin = Factory(:user, :alias => "ADMINMAN", :email => "ADMIN@MAN.JP",
                             :admin => true)
      first = Factory(:conference, :title => "CONFERENCE ONE", :user => admin)
      second = Factory(:conference, :title => "CONFERENCE TWO", :user => admin)
      third = Factory(:conference, :title => "CONFERENCE THREE", :user => admin)

      @conferences = [first, second, third]
      30.times do
        @conferences << Factory(:conference, :title => Factory.next(:title),
                                             :user => admin)
      end
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "ALL DA CONFERENCES")
    end 

    it "should have an element for each conference" do
      get :index
      @conferences[0..2].each do |conference|
        response.should have_selector("li", :content => conference.title)
      end
    end

    it "should paginate conferences" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/conferences?page=2",
                                         :content => "2")
      response.should have_selector("a", :href => "/conferences?page=2",
                                         :content => "Next")
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @conference = Factory(:conference)
    end

    it "should be successful" do
      get :show, :id => @conference
      response.should be_success
    end 

    it "should find the right conference" do
      get :show, :id => @conference
      assigns(:conference).should == @conference
    end

    it "should have the right title" do
      get :show, :id => @conference
      response.should have_selector("title", :content => @conference.title)
    end

    it "should include the conference's title" do
      get :show, :id => @conference
      response.should have_selector("h1", :content => @conference.title)
    end

    it "should include the conference's date" do
      get :show, :id => @conference
      response.should have_selector("div", :content => @conference.date)
    end

    it "should include the conference's location" do
      get :show, :id => @conference
      response.should have_selector("div", :content => @conference.location)
    end

    it "should include a link to the associated user" do
      get :show, :id => @conference
      response.should have_selector("div", :content => @conference.user.alias)
    end
  end

  describe "GET 'new'" do

    before(:each) do
      admin = Factory(:user, :email => "ADMIN@MAN.JP", :alias => "ADMINMAN",
                             :admin => true)
      test_sign_in(admin)
    end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "NEW CONFERENCE")
    end

    it "should have a title field" do
      get :new
      response.should have_selector(
        "input[name='conference[title]'][type='text']"
      )
    end

    it "should have a date field" do
      get :new
      response.should have_selector(
        "input[name='conference[date]'][type='text']"
      )
    end

    it "should have a location field" do
      get :new
      response.should have_selector(
        "input[name='conference[location]'][type='text']"
      )
    end
  end

  describe "POST 'create'" do

    before(:each) do
      admin = Factory(:user, :email => "ADMIN@MAN.JP", :alias => "ADMINMAN",
                             :admin => true)
      test_sign_in(admin)
    end

    describe "failure" do
    
      before(:each) do
        @attr = { :title => "", :date => "", :location => "" }
      end

      it "should not create a conference" do
        lambda do
          post :create, :conference => @attr
        end.should_not change(Conference, :count)
      end

      it "should have the right title" do
        post :create, :conference => @attr
        response.should have_selector("title", :content => "NEW CONFERENCE")
      end

      it "should render the 'new' page" do
        post :create, :conference => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        @attr = {:title => "EXAMPLE CONF OF DOOM!" }
      end

      it "should create a conference" do
        lambda do
          post :create, :conference => @attr
        end.should change(Conference, :count).by(1)
      end

      it "should redirect to the conference show page" do
        post :create, :conference => @attr
        response.should redirect_to(conference_path(assigns(:conference)))
      end

      it "should have a flash message" do
        post :create, :conference => @attr
        flash[:success].should =~ /conference create/i
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      admin = Factory(:user, :alias => "ADMINMAN", :email => "ADMIN@MAN.JP",
                             :admin => true)
      test_sign_in(admin)
      @conference = Factory(:conference, :user => admin)
    end

    it "should be succesful" do
      get :edit, :id => @conference
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @conference
      response.should have_selector("title", :content => "EDIT CONFERENCE")
    end

    it "should have a conference title field" do
      get :edit, :id => @conference
      response.should have_selector(
        "input[name='conference[title]'][type='text']"
      )
    end

    it "should have a conference date field" do
      get :edit, :id => @conference
      response.should have_selector(
        "input[name='conference[date]'][type='text']"
      )
    end

    it "should have a conference location field" do
      get :edit, :id => @conference
      response.should have_selector(
        "input[name='conference[location]'][type='text']"
      )
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      admin = Factory(:user, :alias => "ADMINMAN", :email => "ADMIN@MAN.JP",
                             :admin => true)
      test_sign_in(admin)
      @conference = Factory(:conference, :user => admin)
    end

    describe "failure" do

      before(:each) do
        @attr = { :title => "", :date => "", :location => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @conference, :conference => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @conference, :conference => @attr
        response.should have_selector("title", :content => "EDIT CONFERENCE")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :title => "MUN CONFERENCE OF THE APOC!", :date => "APOC",
                  :location => "HADES" }
      end

      it "should change the conference's attributes" do
        put :update, :id => @conference, :conference => @attr
        @conference.reload
        @conference.title.should == @attr[:title]
        @conference.date.should == @attr[:date]
        @conference.location.should == @attr[:location]
      end

      it "should redirect to the conference's show page" do
        put :update, :id => @conference, :conference => @attr
        response.should redirect_to(conference_path(@conference))
      end

      it "should have a flash message" do
        put :update, :id => @conference, :conference => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      admin = Factory(:user, :email => "ADMIN@MAN.JP", :alias => "ADMINMAN",
                             :admin => true)
      test_sign_in(admin)
      @conference = Factory(:conference, :user => admin)
    end

    it "should destroy the conference" do
      lambda do
        delete :destroy, :id => @conference
      end.should change(Conference, :count).by(-1)
    end

    it "should redirect to the home page" do
      delete :destroy, :id => @conference
      response.should redirect_to(root_path)
    end
  end
end
