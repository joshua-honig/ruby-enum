# frozen_string_literal: true

# Base class for numeric enums
class Enum
  attr_reader :value
  private_class_method :new

  # Class-level cache of values
  @values = {}
  @symbols = []
  @aliases = []

  def name
    @name.to_s
  end

  def to_sym
    @name
  end

  alias key to_sym

  def to_s
    self.class.name + '::' + key.to_s.upcase
  end

  def to_i
    @value
  end

  def names
    keys.map(&:to_s)
  end

  def keys
    [@name].concat(@aliases)
  end

  def key?(sym)
    sym == @name || @aliases.include?(sym)
  end

  def ==(other)
    return false if other.nil?
    case other
    when Integer
      return other == @value
    when self.class
      return true if other.object_id == object_id
      return other.to_i == @value
    end
  end

  def initialize(name, value)
    @value = value.to_i
    @name = name.to_sym
    @aliases = []
  end

  class << self
    def [](key)
      get(key)
    end

    # Get an enum member by string, symbol, or integer value
    def get(value)
      case value
      when Symbol
        @values[value]
      when String
        @values[value.to_sym]
      when Integer
        @values[value]
      end
    end

    # Get an enum member by string, symbol, or integer value.
    # Unlike get, parse will automatically convert strings to numbers,
    # and will trim and downcase strings and symbols
    def parse(value)
      case value
      when Symbol
        sym = value.to_s.strip.downcase.to_sym
        return @values[sym.to_i] if /^\d+/.match? sym
        @values[sym]
      when String
        name = value.strip.downcase
        return @values[name.to_i] if /^\d+/.match? name
        @values[name.to_sym]
      when Integer
        @values[value]
      end
    end

    # Determine whether the provided string, symbol, or integer is a defined enum member
    def include?(value)
      !get(value).nil?
    end

    # Returns the count of defined keys
    def count
      @symbols.count
    end

    alias key_count count

    # Returns the count of unique defined integer values
    def value_count
      values.count
    end

    # Returns the list of defined keys as symbols, sorted by value and then name
    def keys
      @values.values.uniq.sort_by(&:value).map { |e| e.keys.sort }.flatten
    end

    def key?(value)
      @symbols.include? value
    end

    # Returns the list of unique defined integer values
    def values
      @values.values.map(&:to_i).uniq.sort
    end

    private

    # def const_set(name, value)
    #   if value.is_a? self
    #     # Verify that the constant name matches one of the keys
    #     throw ArgumentError.new("Constant name #{name} is not a defined key for this enum value") unless \
    #       value.key?(name.downcase.to_sym)
    #
    #     if const_defined? name
    #       current_val = const_get name
    #
    #       # Ignore redefinition of exact same value, which happens with explicit VALUE = define :value, X
    #       return if current_val == value
    #     end
    #   end
    #
    #   super name, value
    # end

    # Initialize an enum member and define an associated constant on the class singleton
    def define(name, value)
      init name, value, true
    end

    # Initialize an enum member and optionally define an associated constant on the class singleton
    def init(name, value, define_constant = false)
      @values ||= {}
      @symbols ||= []

      s = name.to_sym

      n = s.to_s
      n_lc = n.downcase
      raise ArgumentError.new("Key #{s} is not lower case")  if n != n_lc
      raise ArgumentError.new("Key #{s} already defined") if @values.key? name

      val = value.to_i
      if @values.key? val
        # This is a new alias for an existing value
        enum_val = @values[val]
        enum_val.instance_eval { @aliases << s }
      else
        enum_val = new(s, val)
        @values[val] = enum_val
      end

      @values[s] = enum_val
      @symbols << s

      const_set s.to_s.upcase, enum_val if define_constant

      enum_val
    end
  end
end
