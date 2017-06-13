module UsaliaBot
  module Redis
    extend self

    REDIS = ::Redis::Namespace.new(:usalia)

    def get(key)
      REDIS.get(key)
    end

    def get_json(key)
      get(key) || '{}'
    end

    def set(key, value)
      REDIS.set(key, value)
    end
  end
end
