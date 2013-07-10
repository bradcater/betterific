require 'spec_helper'

describe Betterific::JsonClient do
  [:most_popular, :most_recent].each do |filter|
    it "should load #{filter} betterifs" do
      j = Betterific::JsonClient.betterifs(filter)
      ensure_valid_betterif_json_response(j)
    end
  end
end
