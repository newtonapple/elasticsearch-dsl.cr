module Elasticsearch::DSL::Search::Queries
  class ConstantScore < Base
    Macro.mapping(constant_score, {
      boost:  Type::Number?,
      filter: Base?,
    })

    def filter(query_class : Q.class) forall Q
      q = Q.new
      filter(q)
      with q yield q
      q
    end
  end
end
