module Elasticsearch::DSL::Search::Queries
  class MatchAll
    Macro.mapping(
      match_all: {type: Query, default: Query.new},
    )

    def match_all(&block)
      with @match_all yield @match_all
    end

    class Query
      Macro.mapping(
        boost: Type::Number?,
      )

      def to_json(json : JSON::Builder)
        json.object {
          json.field "boost", boost if boost
        }
      end
    end
  end
end
