redis_config = {
  url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
  network_timeout: 5,
  pool_size: ENV.fetch('RAILS_MAX_THREADS', 5).to_i,
  pool_timeout: 5
}

Redis.current = Redis.new(redis_config)