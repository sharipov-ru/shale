# frozen_string_literal: true

require 'shale/schema/json_generator'
require 'shale/error'

module ShaleSchemaJSONGeneratorTesting
  class BranchOne < Shale::Mapper
    attribute :one, Shale::Type::String

    json do
      map 'One', to: :one
    end
  end

  class BranchTwo < Shale::Mapper
    attribute :two, Shale::Type::String

    json do
      map 'Two', to: :two
    end
  end

  class Root < Shale::Mapper
    attribute :boolean, Shale::Type::Boolean
    attribute :date, Shale::Type::Date
    attribute :float, Shale::Type::Float
    attribute :integer, Shale::Type::Integer
    attribute :string, Shale::Type::String
    attribute :time, Shale::Type::Time
    attribute :value, Shale::Type::Value

    attribute :boolean_default, Shale::Type::Boolean, default: -> { true }
    attribute :date_default, Shale::Type::Date, default: -> { Date.new(2021, 1, 1) }
    attribute :float_default, Shale::Type::Float, default: -> { 1.0 }
    attribute :integer_default, Shale::Type::Integer, default: -> { 1 }
    attribute :string_default, Shale::Type::String, default: -> { 'string' }
    attribute :time_default,
      Shale::Type::Time,
      default: -> { Time.new(2021, 1, 1, 10, 10, 10, '+01:00') }
    attribute :value_default, Shale::Type::Value, default: -> { 'value' }

    attribute :boolean_collection, Shale::Type::Boolean, collection: true
    attribute :date_collection, Shale::Type::Date, collection: true
    attribute :float_collection, Shale::Type::Float, collection: true
    attribute :integer_collection, Shale::Type::Integer, collection: true
    attribute :string_collection, Shale::Type::String, collection: true
    attribute :time_collection, Shale::Type::Time, collection: true
    attribute :value_collection, Shale::Type::Value, collection: true

    attribute :branch_one, BranchOne
    attribute :branch_two, BranchTwo
    attribute :circular_dependency, Root
  end

  class CircularDependencyB < Shale::Mapper
  end

  class CircularDependencyA < Shale::Mapper
    attribute :circular_dependency_b, CircularDependencyB
  end

  class CircularDependencyB
    attribute :circular_dependency_a, CircularDependencyA
  end
end

RSpec.describe Shale::Schema::JSONGenerator do
  let(:expected_schema_hash) do
    {
      '$schema' => 'https://json-schema.org/draft/2020-12/schema',
      '$id' => 'My ID',
      'title' => 'My title',
      'description' => 'My description',
      '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_Root',
      '$defs' => {
        'ShaleSchemaJSONGeneratorTesting_BranchOne' => {
          'type' => %w[object null],
          'properties' => {
            'One' => {
              'type' => %w[string null],
            },
          },
        },
        'ShaleSchemaJSONGeneratorTesting_BranchTwo' => {
          'type' => %w[object null],
          'properties' => {
            'Two' => {
              'type' => %w[string null],
            },
          },
        },
        'ShaleSchemaJSONGeneratorTesting_Root' => {
          'type' => 'object',
          'properties' => {
            'boolean' => {
              'type' => %w[boolean null],
            },
            'date' => {
              'type' => %w[string null],
              'format' => 'date',
            },
            'float' => {
              'type' => %w[number null],
            },
            'integer' => {
              'type' => %w[integer null],
            },
            'string' => {
              'type' => %w[string null],
            },
            'time' => {
              'type' => %w[string null],
              'format' => 'date-time',
            },
            'value' => {
              'type' => %w[string null],
            },
            'boolean_default' => {
              'type' => %w[boolean null],
              'default' => true,
            },
            'date_default' => {
              'type' => %w[string null],
              'format' => 'date',
              'default' => '2021-01-01',
            },
            'float_default' => {
              'type' => %w[number null],
              'default' => 1.0,
            },
            'integer_default' => {
              'type' => %w[integer null],
              'default' => 1,
            },
            'string_default' => {
              'type' => %w[string null],
              'default' => 'string',
            },
            'time_default' => {
              'type' => %w[string null],
              'format' => 'date-time',
              'default' => '2021-01-01T10:10:10+01:00',
            },
            'value_default' => {
              'type' => %w[string null],
              'default' => 'value',
            },
            'boolean_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'boolean' },
            },
            'date_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string', 'format' => 'date' },
            },
            'float_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'number' },
            },
            'integer_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'integer' },
            },
            'string_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string' },
            },
            'time_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string', 'format' => 'date-time' },
            },
            'value_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string' },
            },
            'branch_one' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_BranchOne',
            },
            'branch_two' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_BranchTwo',
            },
            'circular_dependency' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_Root',
            },
          },
        },
      },
    }
  end

  let(:expected_circular_schema_hash) do
    {
      '$schema' => 'https://json-schema.org/draft/2020-12/schema',
      '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_CircularDependencyA',
      '$defs' => {
        'ShaleSchemaJSONGeneratorTesting_CircularDependencyA' => {
          'type' => 'object',
          'properties' => {
            'circular_dependency_b' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_CircularDependencyB',
            },
          },
        },
        'ShaleSchemaJSONGeneratorTesting_CircularDependencyB' => {
          'type' => %w[object null],
          'properties' => {
            'circular_dependency_a' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_CircularDependencyA',
            },
          },
        },
      },
    }
  end

  describe 'json_types' do
    it 'registers new type' do
      described_class.register_json_type('foo', 'bar')
      expect(described_class.get_json_type('foo')).to eq('bar')
    end
  end

  describe '#as_schema' do
    context 'when incorrect argument' do
      it 'raises error' do
        expect do
          described_class.new.as_schema(String)
        end.to raise_error(Shale::NotAShaleMapperError)
      end
    end

    context 'without id' do
      it 'generates schema without id' do
        schema = described_class.new.as_schema(ShaleSchemaJSONGeneratorTesting::Root)
        expect(schema['id']).to eq(nil)
      end
    end

    context 'without title' do
      it 'generates schema without title' do
        schema = described_class.new.as_schema(ShaleSchemaJSONGeneratorTesting::Root)
        expect(schema['title']).to eq(nil)
      end
    end

    context 'without description' do
      it 'generates schema without description' do
        schema = described_class.new.as_schema(ShaleSchemaJSONGeneratorTesting::Root)
        expect(schema['description']).to eq(nil)
      end
    end

    context 'with correct arguments' do
      it 'generates JSON schema' do
        schema = described_class.new.as_schema(
          ShaleSchemaJSONGeneratorTesting::Root,
          id: 'My ID',
          title: 'My title',
          description: 'My description'
        )

        expect(schema).to eq(expected_schema_hash)
      end
    end

    context 'with classes depending on each other' do
      it 'generates JSON schema' do
        schema = described_class.new.as_schema(
          ShaleSchemaJSONGeneratorTesting::CircularDependencyA
        )

        expect(schema).to eq(expected_circular_schema_hash)
      end
    end
  end

  describe '#to_schema' do
    context 'with pretty param' do
      it 'genrates JSON document' do
        schema = described_class.new.to_schema(
          ShaleSchemaJSONGeneratorTesting::Root,
          id: 'My ID',
          title: 'My title',
          description: 'My description',
          pretty: true
        )

        expect(schema).to eq(Shale.json_adapter.dump(expected_schema_hash, :pretty))
      end
    end

    context 'without pretty param' do
      it 'genrates JSON document' do
        schema = described_class.new.to_schema(
          ShaleSchemaJSONGeneratorTesting::Root,
          id: 'My ID',
          title: 'My title',
          description: 'My description'
        )

        expect(schema).to eq(Shale.json_adapter.dump(expected_schema_hash))
      end
    end
  end
end
