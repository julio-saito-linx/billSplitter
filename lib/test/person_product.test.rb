require "person"
require "person_product"
require "test/unit"
require "redgreen"


class TestPersonProduct < Test::Unit::TestCase

  def test_must_have_a_person_and_a_product
    prod1 = Product.new("Beer", 6.0)
    person1 = Person.new("Beer Boy")

    personProduct1 = PersonProduct.new(person1, prod1, :quantity, 1)

    assert_equal("Beer Boy", personProduct1.person.name)
    assert_equal("Beer", personProduct1.product.description)
  end

end
