class Event
  attr_accessor :name, :place, :persons, :itens, :persons_itens, :tips

  def initialize(name)
    @name = name
    @persons = []
    @itens = []
    @persons_itens = []
    @tips = 0.0
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

  def add_person_item(person_name, share_type, share_value, product_description)
    person_item = @persons_itens.find {|x|
                     x.item.product.description == product_description &&
                     x.person.name == person_name}

    if person_item.nil?
      person = @persons.find {|x| x.name == person_name}
      item = @itens.find {|x| x.product.description == product_description}

      person_item = PersonItem.new(person, item)
      @persons_itens.push(person_item)
    end

    person_item.share_type = share_type
    person_item.share_value += share_value
  end

  def total
    acumulator = 0
    @itens.each do |itens|
      acumulator += itens.total
    end
    acumulator + acumulator * @tips
  end

  def total_person(person_name)
    calculate_total
    person = @persons.find {|x| x.name == person_name}
    person.debt
  end

  def calculate_total
    #clear all old debts
    @persons.each do |p1|
      p1.debt = 0
    end

    #iterates each product
    @itens.each do |item|
      product = item.product
      product_total_value = item.total

      #find_all person_item for this product
      persons_item = @persons_itens.find_all do |x|
       x.item.product.description == product.description
      end

      #calculate total under this priority quantity, value, proportion, equality
      #quantity
      pi_by_quantity = persons_item.find_all {|x| x.share_type == :quantity}
      pi_by_quantity.each do |p_item|
        p_item.person.debt += p_item.share_value * p_item.item.product.price
        product_total_value -= p_item.person.debt
      end

      #value
      pi_by_value = persons_item.find_all {|x| x.share_type == :value}
      pi_by_value.each do |p_item|
        p_item.person.debt += p_item.share_value
        product_total_value -= p_item.person.debt
      end

      #proportion
      pi_by_proportion = persons_item.find_all {|x| x.share_type == :proportion}
      pi_by_proportion.each do |p_item|
        p_item.person.debt += p_item.share_value * product_total_value
        product_total_value -= p_item.person.debt
      end

      #equally
      pi_by_equally = persons_item.find_all {|x| x.share_type == :equally}
      persons_sharing = pi_by_equally.count
      pi_by_equally.each do |p_item|
        p_item.person.debt += product_total_value / persons_sharing
      end
    end
  end

end
