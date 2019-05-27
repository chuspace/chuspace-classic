require "./spec_helper"

describe Mobius do
  describe "version" do
    it "should report correct version" do
      Mobius::VERSION.should eq "0.1.0"
    end
  end

  describe "database" do
    it "should have correct DB URL" do
      Mobius::DEFAULT_DATABASE_URL.should eq "postgres://localhost:5432/chuspace_development?sslmode=disable"
    end
  end
end
