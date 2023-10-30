class WeatherDetailer < ApplicationService

  def initialize(weather_info)
    @info = weather_info
  end
  
  def call()
    # details hash will be return value after it's built
    Hash.new.tap do |details|
      details[:location] = {
        name: @info["location"]["name"],
        country_code: @info["location"]["country"],
        postal_code: @info["location"]["zip"]
      }

      details[:current] = extract_point_details(@info["current"], @info["meta"])

      details[:forecast] = @info["forecast"]["list"].map do |point_forecast|
        extract_point_details(point_forecast, @info["meta"])
      end

      details[:cached] = @info["cached"]
    end
  end

  private

  def extract_point_details(point_details, meta)
    point_weather = point_details["weather"].first
    
    {group: point_weather["main"],
     description: point_weather["description"],
     icon: OpenWeather.weather_icon(point_weather["icon"]),
     temp: point_details["main"]["temp"].round,
     temp_min: point_details["main"]["temp_min"].round,
     temp_max: point_details["main"]["temp_max"].round,
     temp_feel: point_details["main"]["feels_like"].round,
     temp_units: meta[:temp_units],
     time: Time.at(point_details["dt"], in: meta["timezone"])}
  end
end
