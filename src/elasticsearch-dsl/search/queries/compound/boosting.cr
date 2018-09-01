module Elasticsearch::DSL::Search::Queries
  class Boosting < Base
    Macro.mapping(boosting, {
      negative_boost: Type::Number?,
      negative:       {type: Base?, assign_with_yield: true},
      positive:       {type: Base?, assign_with_yield: true},
    })
  end
end
