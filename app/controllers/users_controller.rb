class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  before_filter :already_a_user, :only => [:new, :create]

  def index
    @title = "ALL DA USERS"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.alias
  end

  def new
    @user = User.new
    @title = "SIGN UP"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "WELCOME TO THE MODEL UNITED NATIONS APP OF DOOM!"
      redirect_to @user
    else
      @title = "SIGN UP"
      render 'new'
    end
  end

  def edit
    @title = "EDIT USER"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "PROFILE UPDATED!"
      redirect_to @user
    else
      @title = "EDIT USER"
      render 'edit'
    end
  end

  def destroy
    @target = User.find(params[:id])
    unless @target.admin?
     @target.destroy
     flash[:success] = "USER DESTROYED!"
    end
    redirect_to users_path
  end

  private 

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def already_a_user
      redirect_to root_path if signed_in?
    end
end
