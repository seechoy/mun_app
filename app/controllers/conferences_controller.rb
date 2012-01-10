class ConferencesController < ApplicationController
  before_filter :authenticate, :except => [:index, :show] 
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  before_filter :admin_user, :except => [:index, :show]

  def index
    @title = "ALL DA CONFERENCES"
    @conferences = Conference.paginate(:page => params[:page])
  end

  def show
    @conference = Conference.find(params[:id])
    @title = @conference.title
    @user = @conference.user
  end

  def new
    @conference = current_user.conferences.new
    @title = "NEW CONFERENCE"
  end

  def create
    @conference = current_user.conferences.build(params[:conference])
    if @conference.save
      flash[:success] = "CONFERENCE CREATED"
      redirect_to @conference
    else
      @title = "NEW CONFERENCE"
      render 'new'
    end
  end

  def edit
    @title = "EDIT CONFERENCE"
  end

  def update
    @conference = Conference.find(params[:id])
    if @conference.update_attributes(params[:conference])
      flash[:success] = "CONFERENCE UPDATED!"
      redirect_to @conference
    else 
      @title = "EDIT CONFERENCE"
      render 'edit'
    end
  end

  def destroy
    Conference.find(params[:id]).destroy
    flash[:success] = "CONFERENCE DESTROYED!"
    redirect_to root_path
  end

  private

    def authorized_user
      @conference = current_user.conferences.find_by_id(params[:id])
      redirect_to root_path if @conference.nil?
    end
end
