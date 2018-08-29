module Elasticsearch::DSL::Search::Queries
  class Ids < Base
    Macro.mapping(ids, {
      type:   String?,
      values: Array(String)?,
    })
  end
end
