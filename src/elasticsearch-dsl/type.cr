module Elasticsearch::DSL::Type
  alias UInt = UInt8 | UInt16 | UInt32 | UInt64
  alias Int = Int8 | Int16 | Int32 | Int64
  alias Float = Float32 | Float64
  alias Number = UInt | Int | Float
  alias Scalar = String | Number | Bool
  alias ScalarArray = Array(String) |
                      Array(Int) |
                      Array(Float) |
                      Array(Number) |
                      Array(UInt8) |
                      Array(UInt16) |
                      Array(UInt32) |
                      Array(UInt64) |
                      Array(Int8) |
                      Array(Int16) |
                      Array(Int32) |
                      Array(Int64) |
                      Array(UInt) |
                      Array(Float32) |
                      Array(Float64)
end
