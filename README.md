# README

## Prequisites

The app currently uses ruby 3.2.2 and rails 7.1.0

## Running Locallly

**Step 1**

Get an API key from [OpenWeather](https://openweathermap.org/current) It can be a free level api key as the current app only uses the free api endpoints.

**Step 2**

Copy `.env.template` to `.env` and set `OPEN_WEATHER_API_KEY` with your key from above


**Step 3**

Run `bundle install`

**Step 4**

Run `rails s`

## Running the Test Suite

This app uses rspec and can be run using the `rspec` command in your terminal.

It uses the VCR gem to cache external requests to OpenWeather. If you'd like to update those files you can delete them in `spec/support/cassettes` and it will generate new files for any file you've deleted. Some of the cassette data is used in tests to verify other functionality so you may need to update other tests if you decide to do this or some tests will fail.

## Things To Note

The `Hi` & `Lo` values in the current weather card are the highest and lowest temp readings at that time, not the Hi and Lo Temp for the day. These values are not available for the current day as they are not provided specifically and full day info is not included to do a proper calculation.

The time given in any forecast is the local time for the location of the forecast and not necessarily the time of the end user.

OpenWeather appears to do some caching as well and the current weather can be a few minutes behind. To that end, cache calculations are based on the time given by OpenWeather both for current weather and the forecast weather.

The current page was designed to be mobile friendly. with a stark, gothic aesthetic

## Deployment Instructions

The app is currently running on fly.io at [https://vane.fly.dev](https://van.fly.dev). If you would like to deploy this to fly.io yourself you can follow the instructions for [Deploying Existing Rails Apps](https://fly.io/docs/rails/getting-started/existing/). after this runs successfully you will likely need to add a secret for `OPEN_WEATHER_API_KEY` via your fly.io dashboard.
