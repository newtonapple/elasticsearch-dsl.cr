module Elasticsearch::DSL::Search::Queries
  #
  # Constant Score Query AIP:
  #  https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-constant-score-query.html
  class ConstantScore < Base
    Macro.mapping(constant_score, {
      boost:  Type::Number?,
      filter: {type: Base?, assign_with_yield: true},
    })
  end
end
