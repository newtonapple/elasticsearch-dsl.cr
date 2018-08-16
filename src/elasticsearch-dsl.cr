require "json"
require "./elasticsearch-dsl/**"

module Elasticsearch
  # The main module, which can be included in your own class or namespace,
  # to provide the DSL methods:
  #
  # ```
  # include Elasticsearch::DSL
  # definition = search(Queries::Match) {
  #   match {
  #     query "name", "david"
  #   }
  # }
  #
  # definition.to_json
  # # => {"query":"match":{"name":"david"}}
  # ```
  module DSL
    macro included
      include Elasticsearch::DSL::Search
    end
  end
end
