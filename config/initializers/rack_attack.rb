class Rack::Attack
  # Use memory store for the cache
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Safelist local traffic
  safelist('allow-localhost') do |req|
    '127.0.0.1' == req.ip || '::1' == req.ip
  end

  # Throttle requests to 5 requests per 5 seconds per IP
  throttle('req/ip', limit: 5, period: 5.seconds) do |req|
    req.ip
  end

  # Custom throttle response
  self.throttled_responder = lambda do |env|
    now = Time.now.utc
    match_data = env['rack.attack.match_data']

    headers = {
      'Content-Type' => 'application/json',
      'Retry-After' => match_data[:period].to_s,
      'X-RateLimit-Limit' => match_data[:limit].to_s,
      'X-RateLimit-Remaining' => '0',
      'X-RateLimit-Reset' => (now + match_data[:period]).to_s
    }

    [429, headers, [{ error: "Throttle limit reached. Retry later." }.to_json]]
  end

  # Logging configuration
  ActiveSupport::Notifications.subscribe("rack.attack") do |name, start, finish, request_id, payload|
    req = payload[:request]
    Rails.logger.info "[Rack::Attack][#{name}] #{req.ip} - #{req.request_method} #{req.fullpath} - #{payload[:discriminator]}" if Rails.logger
  end
end
