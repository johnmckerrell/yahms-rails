class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout nil
  def config
    headers['Content-type'] = 'text/plain'
    @base_station = BaseStation.find_by_mac_address(params[:mac])
    @analog_inputs = AnalogInput.find( :all,
      :conditions => [ "base_station_id = ? AND deactivated_at IS NULL", @base_station.id ] )
    @digital_outputs = DigitalOutput.find( :all,
      :conditions => [ "base_station_id = ? AND deactivated_at IS NULL", @base_station.id ] )
    @control_blocks = ControlBlock.find( :all,
      :conditions => [ "base_station_id = ? AND deactivated_At IS NULL", @base_station.id ] )
  end

  def submit
    @base_station = BaseStation.find_by_mac_address(params[:mac])
    @base_station.handle_submissions(request.POST)
    render :nothing => true
  end
end
