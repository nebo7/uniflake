module Uniflake::SequenceResolvers

  class Memory

    def initialize
      @sequences = {}
      @last_time = {}
    end

    def resolve(int_generator_id, time, max_value = 0)
      raise "invalid time" if time < @last_time[int_generator_id].to_i

      @sequences[int_generator_id] = time == @last_time[int_generator_id].to_i ? @sequences[int_generator_id].to_i + 1 : 0
      @last_time[int_generator_id] = time
      @sequences[int_generator_id]
    end
  end
end