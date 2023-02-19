module Uniflake::Generators

  class Uniflake
    STRUCTURE = {
      timestamp: 41,
      generator_id: 10,
      sequence: 12
    }

    DEFAULT_EPOCH_START_AT = Time.new(2022, 01, 01)

    MAX_TIMESTAMP = (1 << STRUCTURE[:timestamp]) - 1
    MAX_GENERATOR_ID = (1 << STRUCTURE[:generator_id]) - 1
    MAX_SEQUENCE = (1 << STRUCTURE[:sequence]) - 1

      def initialize(sequence_resolver, epoch_start_at = self::class::DEFAULT_EPOCH_START_AT, generator_id = 0)
      @generator_id = generator_id.to_i
      raise Error, "invalid generator_id (#{@generator_id} > #{self::class::MAX_GENERATOR_ID})" if @generator_id > self::class::MAX_GENERATOR_ID

      @epoch_start_at = epoch_start_at.strftime('%s%L').to_i
      now = Time.now.strftime('%s%L').to_i
      raise Error, "invalid epoch (#{@epoch_start_at} > #{now})" if @epoch_start_at > now

      @sequence_resolver = sequence_resolver
    end

    def generate
      now = Time.now.strftime('%s%L').to_i

      sequence = @sequence_resolver.resolve(@generator_id, now, self::class::MAX_SEQUENCE)
      raise Error, "invalid sequence (#{sequence} > #{self::class::MAX_SEQUENCE})" if sequence > self::class::MAX_SEQUENCE

      timestamp = now - @epoch_start_at
      raise Error, "invalid timestamp (#{timestamp} > #{self::class::MAX_TIMESTAMP})" if timestamp > self::class::MAX_TIMESTAMP

      self.class.compose(timestamp, @generator_id, sequence)
    end

    def self.compose(timestamp, generator_id, sequence)
      shift = 0
      id = 0
      self::STRUCTURE.keys.reverse.each do |field|
        id += binding.local_variable_get(field) << shift
        shift += self::STRUCTURE[field]
      end
      id
    end

    def parse(id)
      fields = self.class.parse(id)
      fields[:timestamp] += @epoch_start_at if fields.has_key? :timestamp
      fields
    end

    def self.parse(id)
      id = id.to_s(2).rjust(self::STRUCTURE.values.sum, "0")
      fields = {}
      self::STRUCTURE.each do |field, length|
        fields[field] = id[0..length - 1].to_i(2)
        id[0..length - 1] = id[length..-1]
      end
      fields
    end
  end
end