require "person"
require "person_product"
require "person_product_agregator"
require "test/unit"
require "redgreen"


class TestPersonProductAgregator < Test::Unit::TestCase

  def setup
    @prod1 = Product.new("Beer", 6.0)
    @person1 = Person.new("Beer Boy")
  end

  def test_quantity_and_value_are_added
    ppAgregator = PersonProductAgregator.new(
      [ PersonProduct.new(@person1, @prod1, :quantity, 10),
        PersonProduct.new(@person1, @prod1, :quantity, 4),
        PersonProduct.new(@person1, @prod1, :quantity, 7),
        PersonProduct.new(@person1, @prod1, :value, 1.0),
        PersonProduct.new(@person1, @prod1, :value, 2.0)])

    assert_equal(21, ppAgregator.total("Beer", :quantity))
    assert_equal(3.0, ppAgregator.total("Beer", :value))
  end

  def test_total_by_proportion_considers_the_last_one
    personProduct1 = PersonProduct.new(@person1, @prod1, :proportion, 0.5)
    personProduct2 = PersonProduct.new(@person1, @prod1, :proportion, 0.75)

    ppAgregator = PersonProductAgregator.new(
      [personProduct1,personProduct2])

    assert_equal(0.75, ppAgregator.total("Beer", :proportion))
  end

  def test_total_by_equality_does_not_apply_any_operation
    personProduct1 = PersonProduct.new(@person1, @prod1, :equality, 0)
    personProduct2 = PersonProduct.new(@person1, @prod1, :equality, 99)

    ppAgregator = PersonProductAgregator.new(
      [personProduct1,personProduct2])

    assert_equal(0, ppAgregator.total("Beer", :equality))
  end


end
