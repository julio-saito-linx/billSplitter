class Person
  attr_accessor :name, :debt, :consumables

  def initialize(name)
    @name = name
    @debt = 0
    @consumables = []
  end
end
