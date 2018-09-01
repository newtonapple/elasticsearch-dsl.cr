module Elasticsearch::DSL::Search::Queries
  #
  #  Dis Max Query AIP:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-dis-max-query.html
  class DisMax < Base
    Macro.mapping(dis_max, {
      boost:       Type::Number?,
      queries:     Array(Base)?,
      tie_breaker: Type::Float?,
    })

    def queries
      @queries ||= Array(Base).new
    end

    def query(query_class : Q.class) forall Q
      q = Q.new
      with q yield q
      queries << q
      q
    end
  end
end
