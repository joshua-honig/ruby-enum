# frozen_string_literal: true

require 'rspec'
require_relative '../app/enum'

RSpec.describe Enum do
  it 'should prevent public new' do
    expect { Enum.new 'One', 1 }.to raise_error(NoMethodError, /private method/)
  end

  it 'should prevent public define' do
    expect { Enum.define 'One', 1 }.to raise_error(NoMethodError, /private method/)
  end
end

class DbOps < Enum
  # INSERT = init 'insert', 1
  # SELECT = init 'select', 2
  # UPDATE = init 'update', 3
  # DELETE = init 'delete', 4
  #
  # CREATE = init 'create', 1
  # READ   = init 'read', 2

  define 'insert', 1
  define 'select', 2
  define 'update', 3
  define 'delete', 4

  define 'create', 1
  define 'read', 2
end

RSpec.describe 'Derived Enum Class' do
  class Numbers < Enum
    define 'one', 1
    define :two, 2
    define 'three', 3
  end

  it 'should allow keys to be defined' do
    expect do
      class MyEnum1 < Enum
        define 'one', 1
      end
    end.not_to raise_error
  end

  it 'allows explicit const assignment with init' do
    expect do
      class Ascii < Enum
        A = init 'a', 1
      end
    end.not_to raise_error
  end

  it 'allows multiple keys for the same value' do
    expect do
      class Ordinals < Enum
        define :first, 1
        define :primary, 1
      end
    end.not_to raise_error
  end

  it 'should accept string or symbol keys' do
    expect do
      class MyEnum2 < Enum
        define 'one', 1
        define :two, 2
      end
    end.not_to raise_error
  end

  it 'should require lower case keys' do
    expect do
      class MyEnum3 < Enum
        define 'One', 1
      end
    end.to raise_error(ArgumentError, /lower/)

    expect do
      class MyEnum3 < Enum
        define :TWO, 2
      end
    end.to raise_error(ArgumentError, /lower/)
  end

  it 'should create upper case constants for each key' do
    expect(Numbers).to have_constant(:ONE)
    expect(Numbers).to have_constant(:TWO)
    expect(Numbers).to have_constant(:THREE)
  end

  it 'should return count of keys' do
    expect(Numbers.count).to eq(3)
  end

  it 'should get items by string, symbol, or int value' do
    one = Numbers::ONE
    expect(Numbers.get('one')).to eq(one)
    expect(Numbers.get(:one)).to eq(one)
    expect(Numbers.get(1)).to eq(one)
  end

  it 'should verify values by string, symbol, or int value' do
    expect(Numbers.include?('one')).to eq(true)
    expect(Numbers.include?(:one)).to eq(true)
    expect(Numbers.include?(1)).to eq(true)

    expect(Numbers.include?('1')).to eq(false)
    expect(Numbers.include?('ONE')).to eq(false)
    expect(Numbers.include?(:ONE)).to eq(false)
  end

  it 'should return the list of symbols sorted by value and name' do
    expect(DbOps.keys).to eq(%i[create insert read select update delete])
  end

  it 'should return the sorted list of unique integer values' do
    expect(DbOps.values).to eq([1, 2, 3, 4])
  end

  it 'should return the same object for different aliases' do
    expect(DbOps::CREATE.object_id).to eq(DbOps::INSERT.object_id)
  end

  it 'should parse numeric, padded, and mixed / upper case strings' do
    create = DbOps::CREATE
    expect(DbOps.parse('Create')).to eq(create)
    expect(DbOps.parse(' inSERT')).to eq(create)
    expect(DbOps.parse(1)).to eq(create)
  end
end

RSpec.describe 'Individual enum values' do
  it 'has a string name, symbol key, and integer value' do
    insert = DbOps::INSERT
    expect(insert.name).to eq('insert')
    expect(insert.key).to eq(:insert)
    expect(insert.value).to eq(1)
  end

  it 'has a list of all names as aliases' do
    insert = DbOps::INSERT
    expect(insert.names).to eq(%w[insert create])
    expect(insert.keys).to eq(%i[insert create])
    expect(insert.value).to eq(1)
  end
end
