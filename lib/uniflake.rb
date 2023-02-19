module Uniflake
  require_relative 'uniflake/generators/uniflake.rb'
  require_relative 'uniflake/generators/snowflake.rb'
  require_relative 'uniflake/generators/discord.rb'

  require_relative 'uniflake/sequence_resolvers/memory.rb'
  require_relative 'uniflake/sequence_resolvers/random.rb'
  require_relative 'uniflake/sequence_resolvers/redis.rb'

  require_relative 'uniflake/generator_ids/number.rb'
end