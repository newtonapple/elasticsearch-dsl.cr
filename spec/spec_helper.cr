require "spec"
require "../src/elasticsearch-dsl"
include Elasticsearch::DSL

module Spec
  struct JSONStringExpectation
    def initialize(@expected_value : String)
    end

    def match(actual_value : T) forall T
      expected = JSON.parse(@expected_value)
      actual = JSON.parse(actual_value.to_json)
      actual == expected
    end

    def failure_message(actual_value : T) forall T
      expected = JSON.parse(@expected_value)
      "Expected:\n#{expected.to_pretty_json}\ngot:\n#{actual_value.to_pretty_json}"
    end
  end

  module JSONExpectations
    def eq_json_str(value : String)
      Spec::JSONStringExpectation.new(value)
    end
  end
end

include Spec::JSONExpectations
