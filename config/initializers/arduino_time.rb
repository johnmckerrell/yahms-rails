# Doing this rather than monkey-patching so that
# it's more clear our use of "weekday" and "minute"
# is non-standard
class ArduinoTime < Time
  def weekday
    return wday + 1
  end

  def minute
    return min
  end
end
