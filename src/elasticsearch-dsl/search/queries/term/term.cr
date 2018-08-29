module Elasticsearch::DSL::Search::Queries
  class Term < Base
    Macro.mapping_with_field_query(term, Type::Scalar, {
      boost: Type::Number?,
      value: Type::Scalar?,
    })
  end
end
