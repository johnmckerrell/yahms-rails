class BaseStation < ActiveRecord::Base
  belongs_to :system
  has_many :analog_inputs
  has_many :control_blocks
  has_many :digital_outputs
  attr_accessible :name, :timezone, :mac_address, :system_id

  def current_time
    t = Time.now.utc
    tz = nil
    if timezone and timezone != ""
      tz = TZInfo::Timezone.get(timezone)
    end
    if tz
      t = tz.utc_to_local(t)
    end
    t = ArduinoTime.at(t)
  end

  def auto_create_input(address)
    matches = address.match(/^X\d+P\d+$/)
    input = nil
    if matches
      type = AnalogInputType.find_by_code('xbeeauto')
      input = AnalogInput.create!(
        :name => "Automatically created #{address}",
        :address => address,
        :size => 10,
        :reference => 3.3,
        :base_station_id => self.id,
        :type_id => type.id)
    end
    input
  end

  def handle_submissions(values)
    analog_inputs = AnalogInput.find( :all, :conditions => [ "base_station_id = ? AND deactivated_at IS NULL", self.id ] )
    inputs_hash = {}
    analog_inputs.each do |i|
      inputs_hash[i.address] = i
    end

    values.each do |address,value|
      input = inputs_hash[address]
      if input.nil?
        input = self.auto_create_input(address)
      end
      # It might not be a valid input address
      if input
        AnalogInputLog.create!(
          :analog_input_id => input.id,
          :value => value.to_i(16) )
      end
    end
  end

  def config_updated!
    begin
      self.config_updated_at = Time.now.utc
      self.save!
      uri = URI.parse("#{LIVE_YAHMS_NET}/u/#{self.mac_address}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      request = Net::HTTP::Get.new(uri.request_uri)
      res = http.request(request)
    rescue Exception => e
      puts "Failed logging an update to config: #{e}"
    end
  end
end
