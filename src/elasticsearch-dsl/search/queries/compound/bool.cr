module Elasticsearch::DSL::Search::Queries
  #
  #  Bool Query AIP:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html
  class BoolQuery < Base
    Macro.mapping(bool, {
      must:                 {type: Base | Array(Base)?, assign_with_yield: true},
      filter:               {type: Base | Array(Base)?, assign_with_yield: true},
      must_not:             {type: Base | Array(Base)?, assign_with_yield: true},
      should:               {type: Base | Array(Base)?, assign_with_yield: true},
      boost:                Type::Number?,
      minimum_should_match: Type::Int | String?,
    })

    {% for query in %w[must filter must_not should] %}
      def {{query.id}}(query : Base)
        if {{query.id}}
          if {{query.id}}.is_a?(Array)
            self.{{query.id}}.as(Array(Base)) << query
          else
            self.{{query.id}} = [{{query.id}}.as(Base), query.as(Base)]
          end
        else
          self.{{query.id}} = query.as(Base)
        end
      end
    {% end %}
  end
end
