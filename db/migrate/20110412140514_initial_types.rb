class InitialTypes < ActiveRecord::Migration
  class DigitalOutputType < ActiveRecord::Base; end
  class AnalogInputType < ActiveRecord::Base; end
  def self.up
    DigitalOutputType.create( :code => "centralheating", :title => "Central Heating System")
    DigitalOutputType.create( :code => "lighting", :title => "Lighting")
    AnalogInputType.create( :code => "temperature", :title => "Temperature Probe" )
    AnalogInputType.create( :code => "power", :title => "Power Monitor" )
    AnalogInputType.create( :code => "xbeeauto", :title => "Xbee Auto" )
  end

  def self.down
    DigitalOutputType.find_by_code( "centralheating" ).destroy
    DigitalOutputType.find_by_code( "lighting" ).destroy
    AnalogInputType.find_by_code( "temperature" ).destroy
    AnalogInputType.find_by_code( "power" ).destroy
    AnalogInputType.find_by_code( "xbeeauto" ).destroy
  end
end
