if Rails.env.test? or Rails.env.development?
  Dotenv.require_keys("OPEN_WEATHER_API_KEY")
end

