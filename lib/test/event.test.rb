require "person"
require "place"
require "product"
require "event"
require "test/unit"
require "redgreen"

class TestEvent < Test::Unit::TestCase

  def setup
    @event1 = Event.new("Joana's birthday")

    @event1.place = Place.new("Elevados Mountain")

    @event1.add_person("Paul Mac")
    @event1.add_person("Will Jack")

    @event1.add_product("Sandwich", 4)
    @event1.add_product("Water", 5)
    @event1.add_product("Beer", 6)
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
