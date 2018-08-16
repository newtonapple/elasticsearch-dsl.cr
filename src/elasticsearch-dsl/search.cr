module Elasticsearch::DSL::Search
  def search(_q : Q.class, &block) forall Q
    search = Search(Q).new
    with search yield search
    search
  end

  def self.search(_a : Q.class, &block) forall Q
    search = Search(Q).new
    with search yield search
    search
  end

  class Search(Q)
    Macro.mapping({
      query:   Q?,
      _source: Array(String) | Bool | String?,
    })

    def query(q : Q = Q.new)
      with q yield q
      self.query = q
    end
  end
end
