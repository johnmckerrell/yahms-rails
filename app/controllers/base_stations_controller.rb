class BaseStationsController < ApplicationController
  before_filter :require_user, :only => [ :new, :create, :edit, :update ]
  before_filter :load_base_station, :only => [ :show, :edit, :update ]
  
  def new
    @base_station = User.new
  end
  
  def create
    if @base_station.save
      flash[:notice] = "Base Station created!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @page_title = "#{@base_station.system.name}: #{@base_station.name} Control Panel"
  end

  def edit
  end
  
  def index
    @system = System.find_authorized_system(params[:system_id], current_user.id)
    @base_stations = BaseStation.where([ "system_id = ?", @system.id ] )
  end

  def update
    if @base_station.update_attributes(params[:base_station])
      @base_station.config_updated!
      flash[:notice] = "Base Station updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  private
  def load_base_station
    @base_station = BaseStation.find(params[:id])
    @system = System.find_authorized_system(@base_station.system_id, current_user.id)
    if @system.nil?
      @base_station = nil
    end
  end

end
