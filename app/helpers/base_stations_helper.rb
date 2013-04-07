module BaseStationsHelper
  def analog_input_widget(input)
    @analog_input = input
    latest_arr = input.recent_logs_humanized(1)
    @analog_input_latest_value = latest_arr.length > 0 ? latest_arr[0] : nil
    begin
      render :partial => "analog_input_widget_#{input.type.code}"
    rescue ActionView::MissingTemplate => e
      begin
        render :partial => "analog_input_widget"
      rescue ActionView::MissingTemplate => e
        ""
      end
    end
  end

  def digital_output_widget(output)
    @digital_output = output
    begin
      render :partial => "digital_output_widget_#{output.type.code}"
    rescue ActionView::MissingTemplate => e
      begin
        render :partial => "digital_output_widget"
      rescue ActionView::MissingTemplate => e
        ""
      end
    end
  end
end

