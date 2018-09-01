module Elasticsearch::DSL::Search::Queries
  class BoolQuery < Base
    Macro.mapping(bool, {
      must:                 Base | Array(Base)?,
      filter:               Base | Array(Base)?,
      must_not:             Base | Array(Base)?,
      should:               Base | Array(Base)?,
      boost:                Type::Number?,
      minimum_should_match: Type::Int | String?,
    })

    {% for query in %w[must filter must_not should] %}
      def {{query.id}}(query_class : Q.class) forall Q
        q = Q.new
        with q yield q
        {{query.id}}(q)
        q
      end

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
