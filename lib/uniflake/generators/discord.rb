module Uniflake::Generators

  class Discord < Uniflake
    # https://en.wikipedia.org/wiki/Snowflake_ID
    DEFAULT_EPOCH_START_AT = Time.new(2015,01,01)
  end

end