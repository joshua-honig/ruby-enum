# frozen_string_literal: true

require_relative './enum'

# Fundamental physical quantity type enum
class QuantityType < Enum
  define 'length', 1
  define 'mass', 2
end
