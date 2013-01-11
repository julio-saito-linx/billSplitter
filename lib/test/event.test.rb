require "../person"
require "../place"
require "../product"
require "../event"
require "test/unit"

class TestEvent < Test::Unit::TestCase

  def setup
    @event1 = Event.new("Joana's birthday")

    @event1.place = Place.new("Elevados Mountain")

    @event1.persons.unshift(Person.new("Paul Mac"))
    @event1.persons.unshift(Person.new("Will Jack"))

    @event1.products.unshift(Product.new("Sandwich"))
    @event1.products.unshift(Product.new("Water"))
    @event1.products.unshift(Product.new("Beer"))
  end

  def test_must_have_a_name
    assert_not_nil(@event1.name)
  end

  def test_happens_at_a_place
    assert_not_nil(@event1.place)
  end

  def test_there_are_two_persons
    assert_equal(2, @event1.persons.count)
  end

  def test_three_products_were_consumed
    assert_equal(3, @event1.products.count)
  end

end
