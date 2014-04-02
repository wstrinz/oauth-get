require_relative 'strategy_dsl'

include StrategyDSL
strategy :jawbone do |s|
  s.client_id         ENV["JAWBONE_CLIENT_ID"]
  s.client_secret     ENV["JAWBONE_CLIENT_SECRET"]
  s.scopes            %w{basic_read extended_read location_read friends_read
                        mood_read mood_write move_read move_write sleep_read
                        sleep_write meal_read meal_write weight_read weight_write
                        cardiac_read cardiac_write generic_event_read generic_event_write}

end
