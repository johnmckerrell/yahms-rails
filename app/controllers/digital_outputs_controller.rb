class DigitalOutputsController < ApplicationController
  before_filter :require_user
  
  def new
    @digital_output = DigitalOutput.new
  end
  
  def create
    #@digital_output = DigitalOutput.new(params[:digital_output])
    if @digital_output.save
      flash[:notice] = "Digital Output created!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @digital_output = DigitalOutput.find(params[:id])
    @system = System.find_authorized_system(@digital_output.base_station.system_id, current_user.id)
    if @system.nil?
      @digital_output = nil
    end
  end

  def edit
    #@digital_output = DigitalOutput.find(params[:id])
  end
  
  def advance
    @digital_output = DigitalOutput.find(params[:id])
    @system = System.find_authorized_system(@digital_output.base_station.system_id, current_user.id)
    if @system.nil?
      @digital_output = nil
    end

    # Check what's currently happening

    # Delete existing transient block

    # Create new transient block if necessary
  end

  def plus_time
    @digital_output = DigitalOutput.find(params[:id])
    @system = System.find_authorized_system(@digital_output.base_station.system_id, current_user.id)
    if @system.nil?
      @digital_output = nil
    end

    if @digital_output.transient_control_block
      @digital_output.transient_control_block.destroy
    end

    t = Time.now
    if @digital_output.base_station.timezone and @digital_output.base_station.timezone != ""
      tz = TZInfo::Timezone.get(@digital_output.base_station.timezone)
      t = tz.utc_to_local(t)
    end
    @digital_output.transient_control_block = ControlBlock.create(
      :minute => t.min,
      :hour => t.hour,
      :day => t.day,
      :month => t.month,
      :year => t.year,
      :weekday => nil,
      :len => params[:minutes].to_i,
      :state => true,
      :base_station_id => @digital_output.base_station_id,
      :digital_output_id => @digital_output.id )
    @digital_output.save!

    redirect_to digital_output_url(:id => @digital_output.id, :minutes => params[:minutes]) 

    # If plus time is done and the time will make it be on for less than the current control block would do, then ignore it

    # Check what's currently happening

    # Delete existing transient block

    # Create new transient block
  end

  def index
    @base_station = BaseStation.find(params[:base_station_id])
    @system = System.find_authorized_system(@base_station.system_id, current_user.id)
    if @system.nil?
      @base_station = nil
    end
    @digital_outputs = DigitalOutput.find(:all,
      :include => [ :type ],
      :conditions => [ "base_station_id = ?", @base_station.id ] )
  end

  def update
    #@digital_output = DigitalOutput.find(params[:id])
    if @digital_output.update_attributes(params[:digital_output])
      flash[:notice] = "Digital Output updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
