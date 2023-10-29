require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:point_detail) do
    {:group=>"Rain",
     :description=>"moderate rain",
     :icon=>:rainy_day,
     :temp=>55,
     :temp_min=>52,
     :temp_max=>56,
     :temp_feel=>54,
     :temp_units=>"F",
     :time=>Time.new("2023-10-29 12:24:02 -0500")}
  end

  let(:point_time) { point_detail[:time] }

  describe "#friendly_date" do
    it "takes a time object and returns a string of MMM DD" do
      expect(helper.friendly_date(point_time)).to eq("Oct 29")
    end
  end

  describe "#friendly_time" do
    it "takes a time object and returns a string of hh:MM(a/p)m in the correct time-zone" do
      expect(helper.friendly_time(point_time)).to eq("12:24pm")
    end
  end

  describe "#friendly_hour" do
    it "takes a time object and returns a string of hh(a/p)m in the correct time-zone" do
      expect(helper.friendly_hour(point_time)).to eq("12pm")
    end
  end

  describe "#temp" do
    it "takes a point_detail and a 'mod option and returns the temp with appropriate units" do
      
      expect(helper.temp(point_detail)).to eq("55°F")
      expect(helper.temp(point_detail, mod: :min)).to eq("52°F")
      expect(helper.temp(point_detail, mod: :max)).to eq("56°F")
      expect(helper.temp(point_detail, mod: :feel)).to eq("54°F")

    end
  end
end
