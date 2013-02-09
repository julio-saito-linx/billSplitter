require "person"
require "place"
require "product"
require "event"
require "person_product"
require "test/unit"
require "redgreen"

class TestEvent < Test::Unit::TestCase

  def setup
    @event1 = Event.new("Joana's birthday")

    @event1.name = "Elevateds Mountains"

    @event1.add_person("Paul")
    @event1.add_person("Will")
    @event1.add_person("Jane")

    @event1.add_item("Sandwich", 4.0, 2)
    @event1.add_item("Water", 5.0, 2)
    @event1.add_item("Beer", 6.0, 8)

    @event1.tip = 0.1
  end

  def test_must_have_a_name
    assert_not_nil(@event1.name)
  end

  def test_there_are_two_persons
    assert_equal(3, @event1.persons.count)
  end

  def test_three_products_were_inserted
    assert_equal(3, @event1.event_itens.count)
  end

  def test_event_total
    assert_equal(66.0, @event1.total)
  end

  def test_event_tips
    assert_equal(6.6, @event1.tip_value)
  end

  def test_event_total_lus_tips
    assert_equal(72.6, @event1.total_plus_tip)
  end

  def test_Paul_eated_a_sandwich
    @event1.add_person_product("Paul", :quantity, 1, "Sandwich")

    person_product1 = @event1.persons_products[0]
    assert_equal("Paul",     person_product1.person.name)
    assert_equal("Sandwich", person_product1.product.description)
  end

  def test_Paul_wants_to_pay_a_share_value
    @event1.add_person_product("Paul", :value, 4.0, "Beer")

    @event1.calculate_total
    assert_equal(4.0, @event1.total_person("Paul"))
  end

  def test_Paul_wants_to_pay_a_share_quantity
    @event1.add_person_product("Paul", :quantity, 1, "Beer")

    @event1.calculate_total
    assert_equal(6.0, @event1.total_person("Paul"))
  end

  def test_Paul_wants_to_pay_a_share_proportion
    @event1.add_person_product("Paul", :proportion, 0.25, "Beer")

    @event1.calculate_total
    assert_equal(12.0, @event1.total_person("Paul"))
  end

  def test_Paul_wants_to_pay_a_share_equality
    @event1.add_person_product("Paul", :equality, 1, "Beer")

    @event1.calculate_total
    assert_equal(48.0, @event1.total_person("Paul"))
  end

  def test_Paul_eated_two_sandwiches
    @event1.add_person_product("Paul", :quantity, 1, "Sandwich")
    @event1.add_person_product("Paul", :quantity, 1, "Sandwich")

    person_product1 = @event1.persons_products[0]

    @event1.calculate_total
    assert_equal(8.0, @event1.total_person("Paul"))
  end

  def test_Paul_and_Will_shared_one_sandwich
    @event1.add_person_product("Paul", :quantity, 0.5, "Sandwich")
    @event1.add_person_product("Will", :quantity, 0.5, "Sandwich")

    @event1.calculate_total
    assert_equal(2.0, @event1.total_person("Paul"))
    assert_equal(2.0, @event1.total_person("Will"))
  end

  def test_Paul_had_all_beers
    @event1.add_person_product("Paul", :proportion, 1, "Beer")

    person_product1 = @event1.persons_products[0]
    assert_equal("Paul", person_product1.person.name)

    @event1.calculate_total
    assert_equal(48.0, @event1.total_person("Paul"))
  end

  def test_Paul_had_half_of_beers
    @event1.add_person_product("Paul", :proportion, 0.5, "Beer")

    person_product1 = @event1.persons_products[0]
    assert_equal("Paul", person_product1.person.name)

    @event1.calculate_total
    assert_equal(24.0, @event1.total_person("Paul"))
  end

  def test_everybody_shared_the_beers
    @event1.add_person_product("Paul", :equality, 0, "Beer")
    @event1.add_person_product("Will", :equality, 0, "Beer")
    @event1.add_person_product("Jane", :equality, 0, "Beer")

    @event1.calculate_total
    assert_equal(16.0, @event1.total_person("Paul"))
    assert_equal(16.0, @event1.total_person("Will"))
    assert_equal(16.0, @event1.total_person("Jane"))
  end


  # def test_nobody_pays_the_same
  #   @event1.add_person_product("Paul", :value,  4.0, "Beer")
  #   @event1.add_person_product("Paul", :quantity, 2, "Beer")

  #   @event1.calculate_total
  #   assert_equal(12.0, @event1.total_person("Paul"))
  # end

  # def test_nobody_pays_the_same
  #   @event1.add_person_product("Paul", :value, 4.0, "Beer")
  #   @event1.add_person_product("Paul", :quantity, 2, "Beer")
  #   @event1.add_person_product("Will", :proportion, 0.50, "Beer")
  #   @event1.add_person_product("Jane", :equality, 0, "Beer")

  #   @event1.calculate_total
  #   assert_equal(20.0, @event1.total_person("Paul"))
  #   assert_equal(14.0, @event1.total_person("Will"))
  #   assert_equal(14.0, @event1.total_person("Jane"))
  # end

end
