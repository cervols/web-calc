require "rails_helper"

RSpec.describe ApiKey, type: :model do
  it "has valid factory" do
    expect(build(:api_key)).to be_valid
  end
end
