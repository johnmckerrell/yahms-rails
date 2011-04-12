class ApiController < ApplicationController
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
end
