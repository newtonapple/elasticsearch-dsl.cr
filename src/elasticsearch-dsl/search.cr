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
    abstract class QueryType
    end
  end

  class Search
    Macro.mapping({
      query:   Queries::QueryType?,
      _source: Array(String) | Bool | String?,
    })

    def query(_q : Q.class) forall Q
      q = Q.new
      with q yield q
      self.query = q
    end

    def query(q : QueryType)
      self.query = q
    end

    def query(q : QueryType, &block)
      with q yield q
      self.query = q
    end
  end
end

require "./**"
