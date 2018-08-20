module Elasticsearch::DSL::Macro
  macro mapping(properties)
    JSON.mapping({{properties}})
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
            json.field field {
              previous_def(pull)
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

    alias QueryType = {{alter_type}} | Query
    property field : String?
    property query :  QueryType?

    def initialize
    end

    def initialize(field : String, query : QueryType)
      {{name.id}}(field, query)
    end

    def to_json(json : JSON::Builder)
      json.object {
        json.field "{{name.id}}" {
          json.object {
            json.field field, query
          }
        }
      }
    end

    def {{name.id}}(field : String, query : QueryType)
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
  end
end
