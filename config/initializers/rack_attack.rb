# frozen_string_literal: true

class Rack::Attack
  LIMIT = 10
  PERIOD = 10

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle('api_ip', limit: LIMIT, period: PERIOD) do |req|
    req.ip
  end
end
