require "product"
require "eventItem"
require "test/unit"
require "redgreen"

class TestEventItem < Test::Unit::TestCase

  def setup
    p1 = Product.new("beer", 4.5)
    @item1 = EventItem.new(p1, 1)
  end

  def test_have_a_counter
    assert_equal(1, @item1.count)
  end

  def test_can_add_new_itens
    @item1.add(2)
    assert_equal(3, @item1.count)
  end

  def test_can_calculate_the_total
    @item1.add(2)
    assert_equal(13.5, @item1.total)
  end

  def test_itens_does_not_have_to_be_one_piece
    @item1.add(-0.5)
    assert_equal(2.25, @item1.total)
  end

end
