require "../person"
require "test/unit"

class TestPerson < Test::Unit::TestCase

  def setup
    @person1 = Person.new("Mario White")
  end

  def test_must_have_a_name
    assert_not_nil(@person1.name)
  end

  def test_starts_with_no_debt
    assert_equal(0, @person1.debt)
  end

  def test_can_have_consumables
    assert_equal(true, @person1.consumables.kind_of?(Array))
    assert_equal(true, @person1.consumables.respond_to?("each"))
  end

end
