module Uniflake::SequenceResolvers

  class Redis

    def initialize(client, key_prefix = '')
      @client = client
      @prefix = key_prefix
    end

    def resolve(int_generator_id, time, max_value = 0)
      last_time = connection.get(@prefix + int_generator_id.to_s + "_last_time").to_i
      raise "invalid time" if time < last_time

      connection.set @prefix + int_generator_id.to_s + "_last_time", time

      connection.eval lua, [@prefix + int_generator_id.to_s + time.to_s], ['0', '10']
    end

    def connection
      if @client.class.method_defined? 'with'
        @client.with { |connection| return connection }
      end

      @client
    end

    def lua
      <<~LUA
        if redis.call('set', KEYS[1], ARGV[1], "EX", ARGV[2], "NX") then
          return 0
        else
          return redis.call('incr', KEYS[1])
        end
      LUA
    end
  end
end