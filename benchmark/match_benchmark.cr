require "benchmark"
require "../elasticsearch-dsl"
include Elasticsearch::DSL

Benchmark.ips(calculation: 5) do |x|
  x.report("Match#to_json") do
    search(Queries::Match) {
      query {
        match "age" {
          query "10"
          operator "and"
          fuzziness 1_u8
        }
      }
    }.to_json
  end

  x.report("Tuple#to_json") do
    {
      query: {
        match: {
          age: {
            query:     "10",
            operator:  "and",
            fuzziness: 1_u8,
          },
        },
      },
    }.to_json
  end

  x.report("Hash#to_json") do
    {
      :query => {
        :match => {
          :age => {
            :query     => "10",
            :operator  => "and",
            :fuzziness => 1_u8,
          },
        },
      },
    }.to_json
  end

  x.report("String substitution") do
    %({"query":{"match":{"age":{"query":"#{"10"}","operator":"#{"and"}","fuzziness":#{1_u8}}}}})
  end

  x.report("JSON.build") do
    json = JSON.build do |j|
      j.object {
        j.field "query" {
          j.object {
            j.field "match" {
              j.object {
                j.field "age" {
                  j.object {
                    j.field "query", "10"
                    j.field "operator", "and"
                    j.field "fuzziness", 1_u8
                  }
                }
              }
            }
          }
        }
      }
    end
  end
end
