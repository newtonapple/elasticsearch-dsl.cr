module Elasticsearch::DSL::Type
  alias UInt = UInt8 | UInt16 | UInt32 | UInt64
  alias Int = Int8 | Int16 | Int32 | Int64
  alias Float = Float32 | Float64
  alias Number = UInt | Int | Float
  alias Scalar = String | Number | Bool
end
