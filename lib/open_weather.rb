class OpenWeather
  URL = 'https://api.openweathermap.org/'
  APP_ID = ENV['OPEN_WEATHER_API_KEY']

  # for how to use thes options please read
  # https://lostisland.github.io/faraday/
  CLIENT_OPTIONS = [
    :request,
    :proxy,
    :ssl,
    :url,
    :parallel_manager,
    :params,
    :headers,
    :builder_class,
    :builder]
  
  UNIT_OPTIONS = {
    "imperial" => {name: "Fahrenheit", unit: "F"},
    "metric"   => {name: "Celcius",    unit: "C"},
    "standard" => {name: "Kelvin",     unit: "K"}
  }
  
  DEFAULT_UNIT = UNIT_OPTIONS.keys.first
  DEFAULT_TIMESTAMPS = 40
  
  GEOCODE_PATH = '/geo/1.0/zip'
  CURRENT_PATH = '/data/2.5/weather'
  FORECAST_PATH = '/data/2.5/forecast'

  ICON_NAMES = {
    "01d" => :clear_day,
    "01n" => :clear_night,
    "02d" => :few_clouds_day,
    "02n" => :few_clouds_night,
    "03d" => :scattered_clouds,
    "03n" => :scattered_clouds,
    "04d" => :broken_clouds,
    "04n" => :broken_clouds,
    "09d" => :shower_rain,
    "09n" => :shower_rain,
    "10d" => :rainy_day,
    "10n" => :rainy_night,
    "11d" => :thunderstorm,
    "11n" => :thunderstorm,
    "13d" => :snow,
    "13n" => :snow,
    "50d" => :mist,
    "50n" => :mist
  }

  ICON_NAMES.default = :clear_day
  
  attr_reader :client, :units, :timestamps
  
  def self.weather_icon(name)
    ICON_NAMES[name]
  end

  def initialize(**opts)
    client_opts = opts.select{|k, v| k.in?(CLIENT_OPTIONS)}
    params = {url: URL, params: {appid: APP_ID}}.merge(client_opts)
               
    @client = Faraday.new(params)
    @units = opts[:units] || DEFAULT_UNIT
    @timestamps = opts[:timestamps] || DEFAULT_TIMESTAMPS
  end
  
  def weather(postal_code, country_code)
    location = geocode(postal_code, country_code)
    
    return location unless location["success"]

    current_weather = current(location["lat"], location["lon"])
    forecast_weather = forecast(location["lat"], location["lon"])

    return current_weather unless current_weather["success"]
    return forecast_weather unless forecast_weather["success"]

    # this assumes these details do not change between
    # calls to the current and forecast endpoints
    meta = {
      temp_units: UNIT_OPTIONS[units][:unit],
      timezone: current_weather["timezone"]}
    
    {location: location,
     meta: meta,
     current: current_weather,
     forecast: forecast_weather,
     success: true}
  end
  
  def geocode(postal_code, country_code)
    params = {zip: "#{postal_code},#{country_code}"}
    response = client.get(GEOCODE_PATH, params)

    JSON.parse(response.env.response_body).tap do |json|
      json["temp_unit"] = UNIT_OPTIONS[units][:unit]
      json["success"] = response.success?
      json["status"] = response.status
      json["type"] = :geocode
    end
  end

  def current(lat, lon)
    params = {lat: lat, lon: lon, units: units}
    
    response = client.get(CURRENT_PATH, params)
    
    JSON.parse(response.env.response_body).tap do |json|
      json["temp_unit"] = UNIT_OPTIONS[units][:unit]
      json["success"] = response.success?
      json["status"] = response.status
      json["type"] = :current
    end
  end

  def forecast(lat, lon, **opts)
    params = {lat: lat, lon: lon, cnt: timestamps, units: units}

    response = client.get(FORECAST_PATH, params)

    JSON.parse(response.env.response_body).tap do |json|
      json["temp_unit"] = UNIT_OPTIONS[units][:unit]
      json["success"] = response.success?
      json["status"] = response.status
      json["type"] = :forecast
    end
  end
end
