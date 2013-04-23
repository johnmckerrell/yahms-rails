class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout false
  def conf
    @base_station = BaseStation.find_by_mac_address(params[:mac])
    if @base_station
      if @base_station.config_updated_at and params[:timestamp].to_i > @base_station.config_updated_at.to_i
        render :nothing => true, :status => 304
      else
        @analog_inputs = AnalogInput.find( :all,
          :conditions => [ "base_station_id = ? AND deactivated_at IS NULL", @base_station.id ] )
        @digital_outputs = DigitalOutput.find( :all,
          :conditions => [ "base_station_id = ? AND deactivated_at IS NULL", @base_station.id ] )
        @control_blocks = ControlBlock.find( :all,
          :conditions => [ "base_station_id = ? AND deactivated_At IS NULL", @base_station.id ] )
      end
    end
  end

  def submit
    @base_station = BaseStation.find_by_mac_address(params[:mac])
    @base_station.handle_submissions(request.POST)
    render :nothing => true
  end

  def test
    render :nothing => true
  end
end
