class PagesController < ApplicationController

  def home
    @title = "HOME"
    @conferences = Conference.paginate(:page => params[:page])
  end

  def contact
    @title = "CONTACT"
  end

  def about
    @title = "ABOUT"
  end

  def help
    @title = "HELP"
  end
end
