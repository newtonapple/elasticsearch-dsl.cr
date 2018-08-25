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
      query:   Queries::Base?,
      _source: Array(String) | Bool | String?,
    })

    def query(_q : Q.class) forall Q
      q = Q.new
      with q yield q
      self.query = q
    end

    def query(q : Base)
      self.query = q
    end

    def query(q : Base, &block)
      with q yield q
      self.query = q
    end
  end
end

require "./**"
