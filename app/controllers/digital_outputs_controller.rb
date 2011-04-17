class DigitalOutputsController < ApplicationController
  before_filter :require_user
  before_filter :load_digital_output, :except => [ :new, :create ]
  
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
  end

  def edit
    #@digital_output = DigitalOutput.find(params[:id])
  end
  
  def advance
    # Check what's currently happening
    active_blocks = @digital_output.active_control_blocks
    state = @digital_output.state_for_blocks(active_blocks)
    new_state = state

    # Delete existing transient block
    if @digital_output.transient_control_block
      @digital_output.transient_control_block.destroy
      active_blocks = @digital_output.active_control_blocks
      new_state = @digital_output.state_for_blocks(active_blocks)
    end

    # Create new transient block if necessary
    t = @digital_output.base_station.current_time
    if new_state != state
      # We've already switched, nothing else to do
    elsif state
      # If on then we need an "off" control block to last to the end
      end_time = nil
      active_blocks.each do |cb|
        block_end_time = cb.current_end_time
        if end_time.nil? or block_end_time > end_time
          end_time = block_end_time
        end
      end
      # There really shouldn't be no end time
      if end_time
        transient_block = ControlBlock.new(
          :len => params[:minutes].to_i,
          :state => false,
          :base_station_id => @digital_output.base_station_id,
          :digital_output_id => @digital_output.id )
        transient_block.set_start_and_end_time(t, end_time)
        transient_block.save!
        @digital_output.transient_control_block = transient_block
        @digital_output.save!
      end
    else
      # If off then we need to find the next start time for each block
      next_start_time = nil
      day_times = [ t, ArduinoTime.at((t+1.day).midnight) ]
      today_blocks = @digital_output.valid_day_blocks(day_times[0])
      tomorrow_blocks = @digital_output.valid_day_blocks(day_times[1])
      day_blocks = [ today_blocks, tomorrow_blocks ]
      day_blocks.each_index do |i|
        blocks = day_blocks[i]
        blocks.each do |cb|
          block_start_time = cb.next_start_time(day_times[i])
          if block_start_time and ( next_start_time.nil? or block_start_time < next_start_time )
            next_start_time = block_start_time
          end
        end
        if next_start_time
          break
        end
      end
      # If there's no start time then there's no valid blocks left
      # today or tomorrow so not much we can do
      if next_start_time
        transient_block = ControlBlock.new(
          :len => params[:minutes].to_i,
          :state => true,
          :base_station_id => @digital_output.base_station_id,
          :digital_output_id => @digital_output.id )
        transient_block.set_start_and_end_time(t,next_start_time)
        transient_block.save!
        @digital_output.transient_control_block = transient_block
        @digital_output.save!
      end
    end
    redirect_to digital_output_url(:id => @digital_output.id, :minutes => params[:minutes]) 
  end

  def plus_time
    if @digital_output.transient_control_block
      @digital_output.transient_control_block.destroy
    end

    t = @digital_output.base_station.current_time
    transient_block = ControlBlock.new(
      :len => params[:minutes].to_i,
      :state => true,
      :base_station_id => @digital_output.base_station_id,
      :digital_output_id => @digital_output.id )
    transient_block.set_start_time(t)
    transient_block.save!
    @digital_output.transient_control_block = transient_block
    @digital_output.save!

    redirect_to digital_output_url(:id => @digital_output.id, :minutes => params[:minutes]) 

    # If plus time is done and the time will make it be on for less than the current control block would do, then ignore it

    # Check what's currently happening

    # Delete existing transient block

    # Create new transient block
  end

  def index
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

  private
  def load_digital_output
    @digital_output = DigitalOutput.find(params[:id])
    @system = System.find_authorized_system(@digital_output.base_station.system_id, current_user.id)
    if @system.nil?
      @digital_output = nil
    end
    if @digital_output and @digital_output.transient_control_block
      cb = @digital_output.transient_control_block
      t = @digital_output.base_station.current_time
      if cb.current_end_time < t
        cb.destroy
        @digital_output.transient_control_block = nil
        @digital_output.save
      end
    end
  end
end
