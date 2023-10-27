require 'rails_helper'

RSpec.describe WeatherDetailer do
  let(:weather_data) do
    # This VCR cassette is just being used here, not tested
    # it is using the 'weather_success' cassette from open_weather_spec.rb
    VCR.use_cassette('weather_success') { OpenWeather.new.weather("55555", "US") }
  end

  let(:weather_details) { WeatherDetailer.call(weather_data) }
  
  it "pulls the approprate sections from the weather data" do
    expect(weather_details).to include(:location, :current, :forecast)
  end

  it "has the appropriate details in the location section" do
    expect(weather_details[:location]).to include(:name, :country_code, :postal_code)
  end

  it "has the appropriate details in the current setion" do
    expect(weather_details[:current]).to(
      include(
        :group, :description, :icon, :temp, :temp_min,
        :temp_max, :temp_feel, :temp_units, :time
      )
    )
  end

  it "rounds the temp info to integers" do
    expect(weather_details[:current][:temp]).to be_a_kind_of(Integer)
    expect(weather_details[:current][:temp_min]).to be_a_kind_of(Integer)
    expect(weather_details[:current][:temp_max]).to be_a_kind_of(Integer)
    expect(weather_details[:current][:temp_feel]).to be_a_kind_of(Integer)
  end

  it "gives a Time Object for the Time value" do
    expect(weather_details[:current][:time]).to be_a_kind_of(Time)
  end

  it "has 40 forecasts in the forecast section" do
    expect(weather_details[:forecast].count).to eq(40)
  end
end
