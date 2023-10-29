require 'rails_helper'

RSpec.describe WeatherController, type: :controller do

  describe "GET show" do
    it "returns a 200" do
      get :show
      
      expect(response).to have_http_status(:ok)
      expect(response).to render_template("show")
    end

    it "returns a 404 with bad data" do
      VCR.use_cassette('weather_error') do 
        get :show, params: {postal_code: "abcde", country_code: "UK"}
        
        expect(response).to have_http_status(:not_found)
        expect(response).to render_template("show")
      end
    end
  end
end
