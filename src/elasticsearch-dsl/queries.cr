module Elasticsearch::DSL::Search
  module Queries
    abstract class Base
    end

    macro def_query_methods_for(query_assign_method = :query)
      def {{query_assign_method.id}}(q : Queries::Base, &block)
        with q yield q
        self.{{query_assign_method.id}} = q
      end

      def {{query_assign_method.id}}
        with self yield self
      end

      {% for query_class in Queries::Base.all_subclasses %}
        {% method_name = query_class.id.split("::").last.underscore.gsub(/_query$/, "").id %}
        def {{method_name}}
          q = {{query_class.id}}.new
          with q yield q
          self.{{query_assign_method.id}} = q
        end
      {% end %}
    end
  end
end
