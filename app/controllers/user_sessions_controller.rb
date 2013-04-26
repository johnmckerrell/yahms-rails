class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :makerfaire]
  before_filter :require_user, :only => :destroy
  
  def makerfaire
    @user_session = UserSession.new(:login=>'makerfaire',:password=>'mosi')
    if @user_session.save
      redirect_to '/base_stations/4'
    else
      redirect_back_or_default systems_url
    end
  end

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default systems_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
