require "person"
require "place"
require "product"
require "event"
require "person_item"
require "test/unit"
require "redgreen"

class TestEvent < Test::Unit::TestCase

  def setup
    @event1 = Event.new("Joana's birthday")

    @event1.place = Place.new("Elevados Mountain")

    @event1.add_person("Paul")
    @event1.add_person("Will")

    @event1.add_item("Sandwich", 4.0, 2)
    @event1.add_item("Water", 5.0, 2)
    @event1.add_item("Beer", 6.0, 8)
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

  def test_three_products_were_inserted
    assert_equal(3, @event1.itens.count)
  end

  def test_event_total_consumed
    assert_equal(66.0, @event1.total)
  end

  def test_Paul_eated_a_sandwich
    @event1.add_person_item("Paul", 1, "Sandwich")

    person_item1 = @event1.persons_itens[0]
    assert_equal("Paul",     person_item1.person.name)
    assert_equal("Sandwich", person_item1.item.product.description)
  end

  def test_Paul_eated_one_more_sandwich
    @event1.add_person_item("Paul", 1, "Sandwich")
    @event1.add_person_item("Paul", 1, "Sandwich")

    person_item1 = @event1.persons_itens[0]
    assert_equal(2, person_item1.count)
  end

  def test_Paul_total_only_sandwiches
    @event1.add_person_item("Paul", 1, "Sandwich")
    @event1.add_person_item("Paul", 1, "Sandwich")

    person_item1 = @event1.persons_itens[0]
    assert_equal(8.0, person_item1.total)
  end

  def test_Paul_and_Will_shared_one_sandwich
    @event1.add_person_item("Paul", 0.5, "Sandwich")
    @event1.add_person_item("Will", 0.5, "Sandwich")

    person_item1 = @event1.persons_itens[0]
    assert_equal("Paul", person_item1.person.name)
    assert_equal(0.5, person_item1.count)
    assert_equal(2.0, person_item1.total)

    person_item2 = @event1.persons_itens[1]
    assert_equal("Will", person_item2.person.name)
    assert_equal(0.5, person_item2.count)
    assert_equal(2.0, person_item2.total)
  end

end
