module Elasticsearch::DSL::Search
  module Sorting
    abstract class Base
    end

    # A simple sort containing only a field and sort order pair.
    class SimpleSort < Base
      property field : String
      property order : String

      def initialize(@field : String, @order : String)
      end

      def to_json(json : JSON::Builder)
        json.object {
          json.field @field, @order
        }
      end
    end

    # A complex sort that contains all optional fields
    class Sort < Base
      Macro.mapping_with_field({
        missing:       String | Type::Scalar?,
        mode:          String?,
        order:         String?,
        unmapped_type: String?,
      })
    end

    # search {
    #   query { match_all { } }
    #   sort("title", "desc")
    #   sort("name")
    #   sort("tags", "asc") {
    #     mode "price"
    #   }
    # }
    module InstanceMethods
      macro included
        def sort(field : String, order : String)
          new_sort = Sorting::SimpleSort.new(field, order)
          sort!(new_sort)
        end

        def sort(field : String, &block)
          new_sort = Sorting::Sort.new(field)
          with new_sort yield new_sort
          sort!(new_sort)
        end

        def sort(new_sort : Sorting::Base)
          sort!(new_sort)
        end

        def sort(field : String)
          sort!(field)
        end

        def sort!(new_sort : Sorting::Base | String)
          if self.sort.is_a?(Array)
            self.sort.as(Array(String | Sorting::Base)) << new_sort
          elsif self.sort.nil?
            self.sort = new_sort
          else
            self.sort = [self.sort.as(String | Sorting::Base), new_sort]
          end
        end
      end
    end
  end
end
