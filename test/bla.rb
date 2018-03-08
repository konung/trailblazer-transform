require "test_helper"
require_relative "flow_test"

module Trailblazer::Transform
  class Entity # aggregate
  end
end

class BlaTest < Minitest::Spec

  amount = Transform::Schema.Scalar(:amount, processor: FlowTest::Amount)
  currency = Transform::Schema.Scalar(:currency, processor: FlowTest::Amount)

  # pp amount.( {document: { amount: "9.1", currency: "1.2" }} )



  price_entity = Module.new do
    extend Trailblazer::Activity::Railway(name: :price)

    pass Subprocess(amount)
    pass Subprocess(currency)
  end

  price_scalar = Transform::Schema.Scalar(:price, processor: price_entity)
  # price_scalar = Transform::Schema.Scalar(:price, processor: entity)


  items_scalar = Transform::Schema.Scalar(:items, processor: Transform::Process::Collection.new(activity: FlowTest::Amount) )

  # the "real" invoice
  invoice_entity = Module.new do
    extend Trailblazer::Activity::Railway(name: :price)

    pass Subprocess( price_scalar )
    pass Subprocess( currency )
    pass Subprocess( items_scalar )
  end

  pp invoice_entity.( {value: { price:{ amount: "9.1", currency: "1.2" }, currency: "8.1",
    items: ["1.1", "2.1"] }} )
raise




  price_entity = Transform::Entity.new(
    [
      Transform::Schema.Scalar(:amount, processor: FlowTest::Amount),
      Transform::Schema.Scalar(:menge, processor: FlowTest::Amount)
    ]
  )
  # returns a "price object (parsed, value, msg)"

  invoice_entity = Transform::Entity.new(
    [
      Transform::Schema.Scalar(:price, processor: price_entity ),
    ]
  )



  document = {
    amount: "1.2",
    menge: "9.9",
  }

puts "yo"
  pp invoice_entity.( [{fragment: document}], {} )
 #{:parsed_fragments=>
 #  {#<Trailblazer::Activity: {amount}>=>"1.2",
 #   #<Trailblazer::Activity: {menge}>=>"9.9"},
 # :values=>
 #  {#<Trailblazer::Activity: {amount}>=>120,
 #   #<Trailblazer::Activity: {menge}>=>990},
 # :messages=>
 #  {#<Trailblazer::Activity: {amount}>=>
 #    #<Dry::Validation::Result output={:value=>"1.2"} errors={}>,
 #   #<Trailblazer::Activity: {menge}>=>
 #    #<Dry::Validation::Result output={:value=>"9.9"} errors={}>}}

end