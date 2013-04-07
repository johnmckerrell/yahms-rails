class AnalogInputsController < ApplicationController
  before_filter :require_user
  
  def new
    @analog_input = User.new
  end
  
  def create
    #@analog_input = AnalogInput.new(params[:analog_input])
    if @analog_input.save
      flash[:notice] = "Analog Input created!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @analog_input = AnalogInput.find(params[:id])
    @system = System.find_authorized_system(@analog_input.base_station.system_id, current_user.id)
    if @system.nil?
      @analog_input = nil
    end

    @analog_input_logs = AnalogInputLog.find(:all,
      :limit => 10,
      :order => "created_at DESC",
      :conditions => [ "analog_input_id = ?", @analog_input.id ] )

    @logs = []
    @analog_input_logs.each do |l|
      @logs << { :created_at => l.created_at, :value => l.value, :human_value => @analog_input.humanize_value(l.value) }
    end
  end

  def edit
    #@analog_input = AnalogInput.find(params[:id])
  end
  
  def index
    @base_station = BaseStation.find(params[:base_station_id])
    @system = System.find_authorized_system(@base_station.system_id, current_user.id)
    if @system.nil?
      @base_station = nil
    end
    @analog_inputs = AnalogInput.find(:all,
      :include => [ :type ],
      :conditions => [ "base_station_id = ?", @base_station.id ] )
  end

  def update
    #@analog_input = AnalogInput.find(params[:id])
    if @analog_input.update_attributes(params[:analog_input])
      flash[:notice] = "Analog Input updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
