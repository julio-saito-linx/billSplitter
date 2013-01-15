class Event
  attr_accessor :name, :place, :persons, :products

  def initialize(name)
    @name = name
    @persons = []
    @products = []
  end

  def add_person(name)
    p1 = Person.new(name)
    @persons.unshift(p1)
  end

  def add_product(name, price)
    p1 = Product.new(name, price)
    @products.unshift(p1)
  end
end
