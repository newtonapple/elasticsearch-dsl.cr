require "./**"

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

  class Search
    alias QueryType = Queries::Common |
                      Queries::MultiMatch |
                      Queries::Match |
                      Queries::MatchAll |
                      Queries::MatchPhrase |
                      Queries::MatchPhrasePrefix

    Macro.mapping({
      query:   QueryType?,
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
