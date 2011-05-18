module BaseStationsHelper
  def analog_input_widget(input)
  end

  def digital_output_widget(output)
    @digital_output = output
    render :partial => "digital_output_widget"
  end
end

