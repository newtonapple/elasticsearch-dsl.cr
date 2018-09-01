module Elasticsearch::DSL::Search
  def search(&block)
    search = Search.new
    with search yield search
    search
  end

  def self.search(&block)
    search = Search.new
    with search yield search
    search
  end

  module Queries
    abstract class Base
    end
  end

  class Search
    Macro.mapping({
      query:   {type: Queries::Base?, assign_with_yield: true},
      _source: Array(String) | Bool | String?,
    })

    def query(q : Query::Base, &block)
      with q yield q
      self.query = q
    end

    def query
      with self yield self
    end
  end
end

require "./**"

module Elasticsearch::DSL::Search
  class Search
    {% for query_class in Queries::Base.all_subclasses %}
      {% method_name = query_class.id.split("::").last.underscore.gsub(/_query$/, "").id %}
      def {{method_name}}
        q = {{query_class.id}}.new
        with q yield q
        self.query = q
      end
    {% end %}
  end
end
