# crystal --version
# Crystal 0.26.0 (2018-08-17)

# LLVM: 6.0.1
# Default target: x86_64-apple-macosx
#
#
# crystal run benchmark/match_benchmark.cr  --release
#       Match#to_json  56.17k (  17.8µs) (± 0.63%)   6246 B/op   1.19× slower
#       Tuple#to_json  66.87k ( 14.95µs) (± 2.31%)   4339 B/op        fastest
#        Hash#to_json  34.89k ( 28.66µs) (± 0.64%)  10688 B/op   1.92× slower
# String substitution  53.06k ( 18.85µs) (± 0.73%)   6348 B/op   1.26× slower
#          JSON.build  65.72k ( 15.22µs) (± 0.63%)   4339 B/op   1.02× slower

require "benchmark"
require "../elasticsearch-dsl"
include Elasticsearch::DSL

queries = [
  {field: "field", query: 10, operator: "and", fuzziness: 1_u8, slop: 1u8},
  {field: "field", query: "male female", operator: "or", fuzziness: 2_u8, slop: 3u8},
  {field: "field", query: "california", operator: "and", fuzziness: 1_u8, slop: 1u8},
  {field: "field", query: "james johnson", operator: "and", fuzziness: 1_u8, slop: 1u8},
  {field: "field", query: 5.7, operator: "and", fuzziness: 1_u8, slop: 1u8},
  {field: "field", query: 125.25, operator: "and", fuzziness: 1_u8, slop: 1u8},
]
template = <<-JSON
     {
       "query": {
         "match": {
           "%{field}": {
             "query": "%{query}",
             "operator": "%{operator}",
             "fuzziness": %{fuzziness}
             }
           }
         }
       }
     }
JSON

template = template.gsub(/\s+/, "")

Benchmark.ips(calculation: 5) do |x|
  x.report("Match#to_json") do
    queries.each do |q|
      search {
        query(Queries::Match) {
          match q[:field] {
            query q[:query]
            operator q[:operator]
            fuzziness q[:fuzziness]
            slop q[:slop]
          }
        }
      }.to_json
    end
  end

  x.report("Tuple#to_json") do
    queries.each do |q|
      {
        query: {
          match: {
            field: {
              query:     q[:query],
              operator:  q[:operator],
              fuzziness: q[:fuzziness],
              slop:      q[:slop],
            },
          },
        },
      }.to_json
    end
  end

  x.report("Hash#to_json") do
    queries.each do |q|
      {
        :query => {
          :match => {
            q[:field] => {
              :query     => q[:query],
              :operator  => q[:operator],
              :fuzziness => q[:fuzziness],
              :slop      => q[:slop],
            },
          },
        },
      }.to_json
    end
  end

  x.report("String substitution") do
    queries.each do |q|
      template % q
    end
  end

  x.report("JSON.build") do
    queries.each do |q|
      json = JSON.build do |j|
        j.object {
          j.field "query" {
            j.object {
              j.field "match" {
                j.object {
                  j.field q[:field] {
                    j.object {
                      j.field "query", q[:query]
                      j.field "operator", q[:operator]
                      j.field "fuzziness", q[:fuzziness]
                      j.field "slop", q[:slop]
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
end
