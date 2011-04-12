module ApiHelper
  def get_pins(arr, prefix)
    pins = []
    arr.each do |a|
      if a.address.start_with?(prefix)
        pins << a.address.slice(1,a.address.length-1)
      end
    end
    pins
  end
end
