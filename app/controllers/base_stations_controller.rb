class BaseStationsController < ApplicationController
  before_filter :require_user
  
  def new
    @base_station = User.new
  end
  
  def create
    #@base_station = BaseStation.new(params[:base_station])
    if @base_station.save
      flash[:notice] = "Base Station created!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    #@base_station = BaseStation.find(params[:id])
  end

  def edit
    #@base_station = BaseStation.find(params[:id])
  end
  
  def index
    @system = System.find_authorized_system(params[:system_id], current_user.id)
    @base_stations = BaseStation.find(:all,
      :conditions => [ "system_id = ?", @system.id ] )
  end

  def update
    #@base_station = BaseStation.find(params[:id])
    if @base_station.update_attributes(params[:base_station])
      flash[:notice] = "Base Station updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
