module Elasticsearch::DSL::Macro
  macro mapping(properties)
    JSON.mapping({{properties}})
    {% for key, type in properties %}
      {% if type.is_a?(HashLiteral) || type.is_a?(NamedTupleLiteral) %}
        {% if type[:assign_with_yield] %}
          def {{key.id}}(_q : Q.class) forall Q
            q = Q.new
            with q yield q
            {{key.id}}(q)
            q
          end
        {% end %}
        {% type = type[:type] %}
      {% end %}

      def {{key.id}}({{key.id}} : {{type}})
        self.{{key.id}} = {{key.id}}
      end
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

  macro mapping(name, properties)
    Macro.mapping({{properties}})

    def {{name.id}}
      with self yield self
      self
    end

    def to_json(json : JSON::Builder)
      json.object {
        json.field "{{name.id}}" {
          previous_def(json)
        }
      }
    end
  end

  macro mapping_with_field(name, properties)
    property field : String?
    Macro.mapping({{properties}})

    def initialize(field : String)
      self.field = field
    end

    def to_json(json : JSON::Builder)
      json.object {
        json.field "{{name.id}}" {
          json.object {
            json.field(field) {
              previous_def(json)
            }
          }
        }
      }
    end

    def {{name.id}}(field : String)
      self.field = field
      with self yield self
    end
  end

  macro mapping_with_field_query(name, alter_type, properties)
    class Query
      Macro.mapping({{properties}})
    end

    alias Base = {{alter_type}} | Query
    property field : String?
    property query : Base?
    property _name : String?

    def initialize
    end

    def initialize(field : String, query : Base)
      {{name.id}}(field, query)
    end

    def to_json(json : JSON::Builder)
      json.object {
        json.field "{{name.id}}" {
          json.object {
            json.field field, query
            json.field("_name", self._name) if self._name
          }
        }
      }
    end

    def {{name.id}}(field : String, query : Base)
      self.field = field
      self.query = query
    end

    def {{name.id}}(field : String)
      self.field = field
      self.query ||= Query.new
      with @query.as(Query) yield @query
    end

    def {{name.id}}!(field : String)
      self.field = field
      self.query = Query.new
      with @query.as(Query) yield @query
    end

    def _name(name : String)
      self._name = name
    end
  end
end
