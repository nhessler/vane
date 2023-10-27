require 'rails_helper'

RSpec.describe OpenWeather do
  let(:open_weather) { OpenWeather.new }
  let(:good_lat_lon) { {"lat" => 30.4036, "lon" => -97.7526} }
  context '.weather_icon' do
    let (:good_icon_id) { "01n" }
    let (:bad_icon_id) { "99z" }
    
    it "gives back the corresponding icon name when given a proper OW icon id" do
      expect(OpenWeather.weather_icon(good_icon_id)).to eq(:clear_night)
    end

    it "gives back the default icon name when given a bd OW icon id" do
      expect(OpenWeather.weather_icon(bad_icon_id)).to eq(:clear_day)
    end
  end
  
  context '#geocode' do
    it "responds with the valid lat and lon info for a postal code and country code" do
      response = VCR.use_cassette('geocode_success') { open_weather.geocode("78759", "US") }
      
      expect(response).to include(good_lat_lon)
    end

    it "returns a 404 error when unable to determine location" do
      response = VCR.use_cassette('geocode_error') { open_weather.geocode("abcde", "US") }
      
      expect(response).to include("cod" => "404", "message" => "not found")
    end
  end

  context "#current" do
    it "responds with the current weather info given a proper lat and lon" do
      glat, glon = good_lat_lon.values
      response = VCR.use_cassette('current_success') { open_weather.current(glat, glon) }

      expect(response).to include("weather", "main")
    end

    it "returns a 400 error when unable to use lat and lon to find location" do
      blat, blon = "78759", "US"
      response = VCR.use_cassette('current_error') { open_weather.current(blat, blon) }

      expect(response).to include("cod" => "400", "message" => "wrong latitude")
    end
  end

  context "#forecast" do
    it "responds with the forecast weather info given a proper lat and lon" do
      glat, glon = good_lat_lon.values
      response = VCR.use_cassette('forecast_success') { open_weather.forecast(glat, glon) }

      expect(response).to include("list")
      expect(response["list"].count).to eq(40)
      expect(response["list"].sample).to include("weather", "main")
    end

    it "returns a 400 error when unable to use lat and lon to find location" do
      blat, blon = "78759", "US"
      response = VCR.use_cassette('forecast_error') { open_weather.current(blat, blon) }

      expect(response).to include("cod" => "400", "message" => "wrong latitude")
    end
  end

  context "#weather" do
    it "responds with all the location and weather data given a good postal_code and country_code" do
      response = VCR.use_cassette('weather_success') { open_weather.weather("55555", "US") }

      expect(response).to include(:location, :meta, :current, :forecast, :success)
    end

    it "returns a 404 error when unable to determine location" do
      response = VCR.use_cassette('weather_error') { open_weather.weather("abcde", "UK") }

      expect(response).to include("cod" => "404", "message" => "not found")
    end
  end
end
