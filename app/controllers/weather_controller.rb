class WeatherController < ApplicationController
  def show
    @postal_code = params[:postal_code].presence
    @country_code = params[:country_code].presence || "US"

    @countries = country_codes

    get_data 
    get_details
    render :show, status: @status
  end

  def country_codes
    COUNTRY_CODES_HASH.map do | row |
      [row["Country Name"], row["ISO 3166-1 Alpha-2 Code"]]
    end
  end

  def params_present?
    @postal_code.present? && @country_code.present?
  end

  def get_data
    @data = if params_present?
      OpenWeather.new.weather(@postal_code, @country_code)
    end
  end

  def get_details
    if @data.blank?
      @status = :ok
    elsif @data["success"]
      @details = WeatherDetailer.call(@data)
      @status = :ok
    else
      flash.now[:alert] = "Please verify Postal Code and Country are correct"
      @status = :not_found
    end
  end
end
