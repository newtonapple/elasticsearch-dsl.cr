module Elasticsearch::DSL::Search::Queries
  class Match
    alias QueryType = Type::Scalar | Query
    property field : String?
    property query : QueryType?

    def initialize
    end

    def initialize(pull : JSON::PullParser)
      pull.read_object { |match|
        if match != "match"
          raise "Expect keyword \"match\""
        end
        pull.read_object { |field|
          @field = field
          @query = QueryType.new(pull)
        }
      }
    end

    def initialize(@field : String, @query : QueryType)
    end

    def match(@field : String, &block)
      @query ||= Query.new
      with @query.as(Query) yield @query
    end

    def match(@field : String, query : QueryType)
      @query = query
    end

    def to_json(json : JSON::Builder)
      json.object {
        json.field "match" {
          json.object {
            json.field @field, @query
          }
        }
      }
    end

    class Query
      Macro.mapping({
        analyzer:             String?,
        boost:                Type::Number?,
        cutoff_frequency:     Type::Float?,
        fuzziness:            UInt8 | String?,
        fuzzy_rewrite:        String?,
        fuzzy_transpositions: Bool?,
        lenient:              Bool?,
        max_expansions:       Type::UInt?,
        minimum_should_match: Type::Int | String?,
        operator:             String?,
        prefix_length:        Type::UInt?,
        query:                Type::Scalar?,
        slop:                 UInt8?,
        type:                 String?,
        zero_terms_query:     String?,
      })
    end
  end
end
