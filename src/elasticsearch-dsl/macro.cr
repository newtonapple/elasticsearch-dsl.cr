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

  macro named_mapping(name, properties)
    Macro.mapping({{properties}})

    def {{name.id}}
      with self yield self
      self
    end

    def initialize(pull : JSON::PullParser)
      pull.read_object { |{{name}}|
        if {{name}} != "{{name.id}}"
          raise "Received \"#{{{name}}}\" instead of \"{{name.id}}\"."
        end
        previous_def(pull)
      }
    end

    def to_json(json : JSON::Builder)
      json.object {
        json.field "{{name.id}}" {
          previous_def(json)
        }
      }
    end
  end
end
