class AttendancesController < ApplicationController
  before_filter :authenticate

  def create
    @conference = User.find(params[:attendance][:conference_id])
    current_user.attend!(@conference)
    respond_to do |format|
      format.html { redirect_to @conference }
      format.js
    end
  end

  def destroy
    @conference = Attendance.find(params[:id]).conference
    current_user.unattend!(@conference)
    respond_to do |format|
      format.html { redirect_to @conference }
      format.js
    end
  end
end
