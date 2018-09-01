module Elasticsearch::DSL::Search::Queries
  class ConstantScore < Base
    Macro.mapping(constant_score, {
      boost:  Type::Number?,
      filter: Base?,
    })

    def filter(query_class : Q.class) forall Q
      q = Q.new
      with q yield q
      filter(q)
      q
    end
  end
end
