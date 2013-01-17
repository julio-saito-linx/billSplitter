class Event
  attr_accessor :name, :place, :persons, :itens, :persons_itens

  def initialize(name)
    @name = name
    @persons = []
    @itens = []
    @persons_itens = []
  end

  def add_item(name, price, item_count)
    product1 = Product.new(name, price)
    item1 = EventItem.new(product1, item_count)
    @itens.unshift(item1)
  end

  def add_person(name)
    p1 = Person.new(name)
    @persons.unshift(p1)
  end

  def add_person_item(person_name, count, product_description)
    person_item = @persons_itens.find {|x|
                     x.item.product.description == product_description &&
                     x.person.name == person_name}

    if person_item.nil?
      person = @persons.find {|x| x.name == person_name}
      item = @itens.find {|x| x.product.description == product_description}

      person_item = PersonItem.new(person, item)
      @persons_itens.push(person_item)
    end

    person_item.count += count
  end

  def total
    acumulator = 0
    @itens.each do |itens|
      acumulator += itens.total
    end
    acumulator
  end

end
