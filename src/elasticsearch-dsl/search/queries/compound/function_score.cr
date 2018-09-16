module Elasticsearch::DSL::Search::Queries
  #
  # Function score compound query API:
  #   [https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html]
  class FunctionScore < Base
    # All score functions are subclasses of
    # the abstract class `Function` except for
    # the `weight` function
    abstract class Function
      def self.field_name
        {% begin %}
          "{{@type.id.split("::").last.underscore.id}}"
        {% end %}
      end
    end

    {% for decay_function in %w[gauss exp linear] %}
      class {{decay_function.id.capitalize}} < Function
        property field : String?
        property multi_value_mode : String?

        Macro.mapping({
          decay:  Type::Number?,
          origin: Type::Number | String?,
          offset: Type::Number | String?,
          scale:  Type::Number | String?,
        })

        def initialize(@field : String)
        end

        def multi_value_mode(@multi_value_mode : String)
        end

        def to_json(json : JSON::Builder)
          json.object {
            json.field(@field) {
              previous_def(json)
            }
            json.field("multi_value_mode", @multi_value_mode) if @multi_value_mode
          }
        end
      end
    {% end %}

    class FieldValueFactor < Function
      Macro.mapping({
        factor:   Type::Number?,
        field:    String?,
        missing:  Type::Number?,
        modifier: String?,
      })
    end

    class RandomScore < Function
      Macro.mapping({
        seed:  Type::Int?,
        field: String?,
      })
    end

    class ScriptScore < Function
      Macro.mapping(script, {
        params: Hash(String, Type::Scalar)?,
        source: String?,
      })
    end
  end

  # Macro for FunctionScore
  module Macro::FunctionScore
    macro define_functions
      {% for function_class in Elasticsearch::DSL::Search::Queries::FunctionScore::Function.all_subclasses %}
        {% method_name = function_class.id.split("::").last.underscore.id %}
        def {{method_name}}
          q = {{function_class.id}}.new
          with q yield q
          @function = q
        end
      {% end %}

      {% for decay_function in %w[gauss exp linear] %}
        def {{decay_function.id}}(field : String)
          decay_function = Elasticsearch::DSL::Search::Queries::FunctionScore::{{decay_function.capitalize.id}}.new(field)
          with decay_function yield decay_function
          @function = decay_function
        end
      {% end %}
    end
  end

  class FunctionScore < Base
    Macro.mapping(function_score, {
      boost:      Type::Number | String?,
      boost_mode: String?,
      function:   {type: Function | Array(CombinedFunction) | Type::Number?, key: function_field_name},
      max_boost:  Type::Number?,
      min_score:  Type::Number?,
      query:      {type: Base?, assign_with_yield: true},
      score_mode: String?,
    })

    def function_field_name
      if function.is_a?(Array)
        "functions"
      elsif function.is_a?(Type::Number)
        "weight"
      else
        function.as(Function).class.field_name
      end
    end

    def function
      func = CombinedFunction.new
      with func yield func
      unless @function.is_a?(Array)
        @function = Array(CombinedFunction).new
      end
      @function.as(Array) << func
    end

    def weight=(weight : Type::Number)
      @function = weight
    end

    def weight(weight : Type::Number)
      @function = weight
    end

    class CombinedFunction
      Macro.mapping({
        filter:   {type: Base?, assign_with_yield: true},
        function: {type: Function?, key: function_field_name},
        weight:   Type::Number?,
      })

      def function_field_name
        function.as(Function).class.field_name
      end

      Macro::FunctionScore.define_functions
    end

    Macro::FunctionScore.define_functions
  end
end
