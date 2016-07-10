class ApplicationController < ActionController::API
  config.cache_store = :redis_store, { host: "localhost",
                                       port: 6379,
                                       db: 0,
                                       namespace: "cache",
                                       expires_in: 1.days }
end
