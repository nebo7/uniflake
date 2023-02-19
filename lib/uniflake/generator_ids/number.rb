module Uniflake

  class Number
    BIT_LENGTH = 10
    MAX_ID = (1 << BIT_LENGTH) - 1

    attr_reader :id

    def initialize(id = 0)
      raise OverflowError, "invalid generator id (#{id} > #{MAX_ID})" if id > MAX_ID
      @id = id
    end

    def to_i
      @id
    end
  end
end