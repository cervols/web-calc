require "rails_helper"

RSpec.describe Rack::Attack, type: :request do
  let(:ip) { "1.2.3.4" }
  let(:access_token) { create(:api_key).access_token }
  let(:expression) { "1.2.3.4" }
  let(:limit) { Rack::Attack::LIMIT }
  let(:period) { Rack::Attack::PERIOD }

  subject do
    get "/", headers: { REMOTE_ADDR: ip, Authorization: "Token token=#{access_token}" }, params: { expression: expression }
  end

  context "when number of requests is lower than the limit" do
    before do
      (limit - 1).times do
        Rack::Attack.cache.count("api_ip:#{ip}", period)
      end
    end

    it "does not throttle requests by IP address" do
      subject

      expect(response).to_not have_http_status(:too_many_requests)
    end
  end

  context "when number of requests is higher than the limit" do
    before do
      limit.times do
        Rack::Attack.cache.count("api_ip:#{ip}", period)
      end
    end

    it "throttle excessive requests by IP address" do
      subject

      expect(response).to have_http_status(:too_many_requests)
    end
  end
end
