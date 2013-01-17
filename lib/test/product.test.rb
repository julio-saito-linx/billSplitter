require "product"
require "test/unit"
require "redgreen"


class TestProduct < Test::Unit::TestCase

  def setup
    @product1 = Product.new("Pedaco de Pizza de Mussarela", 10)
  end

  def test_must_have_a_description
    assert_not_nil(@product1.description)
  end

  def test_price_have_a_value
    assert_equal(10, @product1.price)
  end

  def test_price_can_be_changed
    @product1.price = 4.0
    assert_equal(4, @product1.price)
  end

end

