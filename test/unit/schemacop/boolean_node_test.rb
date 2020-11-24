require 'test_helper'

module Schemacop
  class BooleanNodeTest < SchemacopTest
    EXP_INVALID_TYPE = 'Invalid type, expected "boolean".'.freeze

    def test_basic
      schema :boolean

      assert_validation true
      assert_validation false

      assert_json(type: :boolean)
    end

    def test_hash
      schema { boo! :alive }
      assert_json(
        type:                 :object,
        properties:           {
          alive: { type: :boolean }
        },
        required:             %i[alive],
        additionalProperties: false
      )
      assert_validation alive: true
      assert_validation alive: false
    end

    def test_type
      schema :boolean

      assert_json(type: :boolean)

      assert_validation 42 do
        error '/', EXP_INVALID_TYPE
      end

      [:true, 'true', :false, 'false', 0, 1].each do |value|
        assert_validation value do
          error '/', EXP_INVALID_TYPE
        end
      end

      schema { boo? :name }

      assert_json(
        type:                 :object,
        properties:           {
          name: { type: :boolean }
        },
        additionalProperties: false
      )

      [:true, 'true', :false, 'false', 0, 1].each do |value|
        assert_validation name: value do
          error '/name', EXP_INVALID_TYPE
        end
      end
    end
  end
end
