# frozen_string_literal: true

class Measurer
  attr_reader :system

  def initialize(system = :metric)
    raise ArgumentError.new("Invalid system #{system}") unless %i[metric imperial].include? system.to_sym
    @system = system.to_sym
  end
end
