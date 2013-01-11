require "../product"
require "test/unit"

class TestProduct < Test::Unit::TestCase

  def setup
    @product1 = Product.new("Pedaco de Pizza de Mussarela")
  end

  def test_must_have_a_description
    assert_not_nil(@product1.description)
  end

  def test_unit_price_is_zero_at_start
    assert_equal(0, @product1.unit_price)
  end

  def test_unit_price_can_be_changed
    @product1.unit_price = 4.0
    assert_equal(4, @product1.unit_price)
  end

end

