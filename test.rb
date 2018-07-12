# frozen_string_literal: true

require './app/quantity_type'

# QuantityType.define(QuantityType, 'fpp', 2)

puts "QuantityType::LENGTH : #{QuantityType::LENGTH}"
puts "QuantityType::LENGTH.name : #{QuantityType::LENGTH.name}"
puts "QuantityType::LENGTH.value : #{QuantityType::LENGTH.value}"
puts "QuantityType::LENGTH.to_s : #{QuantityType::LENGTH}"
puts "QuantityType::LENGTH.to_i : #{QuantityType::LENGTH.to_i}"
puts QuantityType::LENGTH == 1
puts QuantityType::LENGTH == QuantityType.get(1)
puts QuantityType::LENGTH == QuantityType.get('length')
