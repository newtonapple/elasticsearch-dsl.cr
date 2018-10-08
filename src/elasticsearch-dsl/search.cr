require "./**"

module Elasticsearch::DSL::Search
  def search(&block)
    search = Search.new
    with search yield search
    search
  end

  def self.search(&block)
    search = Search.new
    with search yield search
    search
  end

  class Search
    # Search request body parameters:
    #   https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-body.html#_parameters_4
    Macro.mapping({
      batched_reduce_size: Type::UInt?,
      explain:             Bool?,
      from:                Type::UInt?,
      min_score:           Type::Number?,
      query:               {type: Queries::Base?, assign_with_yield: true},
      rescore:             Rescoring::Rescore | Array(Rescoring::Rescore)?,
      size:                Type::UInt?,
      stats:               Array(String)?,
      stored_fields:       Array(String) | String?,
      sort:                Array(String | Sorting::Base) | Sorting::Base | String?,
      terminate_after:     Type::UInt?,
      timeout:             String?,
      version:             Bool?,
      _source:             Array(String) | Bool | String?,
    })

    Queries.def_query_methods_for(query)
    include Rescoring::InstanceMethods
    include Sorting::InstanceMethods
  end
end
