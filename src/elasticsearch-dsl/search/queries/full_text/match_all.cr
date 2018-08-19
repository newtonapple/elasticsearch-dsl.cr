module Elasticsearch::DSL::Search::Queries
  class MatchAll
    Macro.mapping(match_all, {
      boost: Type::Number?,
    })

    def match_all
    end

    def match_all(@boost : Type::Number)
    end

    def to_json(json : JSON::Builder)
      json.object {
        json.field "match_all" {
          json.object {
            json.field "boost", boost if boost
          }
        }
      }
    end
  end
end
