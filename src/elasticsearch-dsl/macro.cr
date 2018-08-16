module Elasticsearch::DSL::Macro
  macro mapping(properties)
    JSON.mapping( {{properties}} )
    {% for key, type in properties %}
      {% if type.is_a?(HashLiteral) || type.is_a?(NamedTupleLiteral) %}
        def {{key.id}}({{key.id}} : {{type[:type]}})
          self.{{key.id}} = {{key.id}}
        end
      {% else %}
        def {{key.id}}({{key.id}} : {{type}})
          self.{{key.id}} = {{key.id}}
        end
      {% end %}
    {% end %}

    def initialize
      {% for key, type in properties %}
        {% if (type.is_a?(HashLiteral) || type.is_a?(NamedTupleLiteral)) && type[:default] %}
           @{{key.id}} = {{type[:default]}}
        {% end %}
      {% end %}
    end
  end

  macro mapping(**properties)
    Macro.mapping({{properties}})
  end
end