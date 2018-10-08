require "./queries"
require "./search/queries/**"

module Elasticsearch::DSL::Search
  #
  # Search request rescoring API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-rescore.html
  module Rescoring
    class Rescore
      Macro.mapping({
        query:       Query?,
        window_size: Type::UInt?,
      })

      def query
        q = Query.new
        with q yield q
        self.query = q
      end

      class Query
        Macro.mapping({
          query_weight:         Type::Number?,
          rescore_query:        {type: Queries::Base?, assign_with_yield: true},
          rescore_query_weight: Type::Number?,
          score_mode:           String?,
        })

        Queries.def_query_methods_for(rescore_query)
      end
    end

    module InstanceMethods
      macro included
        def rescore(new_rescore : Rescoring::Rescore)
          rescore!(new_rescore)
        end

        def rescore(new_rescore = Rescoring::Rescore.new)
          with new_rescore yield new_rescore
          rescore!(new_rescore)
        end

        def rescore!(new_rescore : Rescoring::Rescore)
          if self.rescore.is_a?(Array)
            self.rescore.as(Array(Rescoring::Rescore)) << new_rescore
          elsif self.rescore.nil?
            self.rescore = new_rescore
          else
            self.rescore = [self.rescore.as(Rescoring::Rescore), new_rescore]
          end
        end
      end
    end
  end
end
