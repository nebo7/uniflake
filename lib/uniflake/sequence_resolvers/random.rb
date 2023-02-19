module Uniflake::SequenceResolvers

  class Random

    def initialize
      @prng = Random.new
    end

    def resolve(int_generator_id, time, max_value = 0)
      raise "invalid time" if time < @last_time.to_i
      @last_time = time
      @prng.rand max_value
    end
  end
end