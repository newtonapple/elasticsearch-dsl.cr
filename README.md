# elasticsearch-dsl

A [Crystal](https://crystal-lang.org/) DSL for Elasticsearch.  It is partially inspired by the [Ruby Elasticsearch DSL](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-dsl).

## WARNING:
THIS LIBRARY IS A WORK IN PROGRESS & API IS A MOVING TARGET.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  elasticsearch-dsl:
    github: newtonapple/elasticsearch-dsl
```

## Usage

```crystal
require "elasticsearch-dsl"

include Elasticsearch::DSL::Search
include Queries

bool_query = search {
  query {
    bool {
      must(MultiMatch) {
        fields ["title^2", "description", "body"]
        query "metaprogramming"
      }
      should(MatchPhrase) {
        match_phrase("body") {
          query "crystal magic"
        }
      }
    }
  }
}

puts bool_query.to_pretty_json
# =>
# {
#   "query": {
#     "bool": {
#       "must": {
#         "multi_match":{
#           "fields": ["title^2", "description", "body"],
#           "query": "metaprogramming"
#         }
#       },
#       "should": {
#         "match_phrase": {
#           "body": {
#             "query": "crystal magic"
#           }
#         }
#       }
#     }
#   }
# }
```

Please see spec for more examples.

## Contributors

- [newtonapple](https://github.com/newtonapple) David Dai - creator, maintainer
