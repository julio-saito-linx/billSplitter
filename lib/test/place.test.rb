require "place"
require "test/unit"
require "redgreen"


class TestPlace < Test::Unit::TestCase

  def setup
    @place1 = Place.new("Mario's Restaurant")
  end

  def test_have_a_product_list
    assert_not_nil(@place1.products)
  end
end

