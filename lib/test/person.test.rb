require "person"
require "test/unit"
require "redgreen"


class TestPerson < Test::Unit::TestCase

  def setup
    @person1 = Person.new("Mario White")
  end

  def test_must_have_a_name
    assert_not_nil(@person1.name)
  end

end
