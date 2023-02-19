module Uniflake::Generators

  class Snowflake < Uniflake
    # https://en.wikipedia.org/wiki/Snowflake_ID
    DEFAULT_EPOCH_START_AT = Time.at(0, 1288834974657, :millisecond)
  end

end