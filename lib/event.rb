require 'logger'

class Event
  attr_accessor :name, :persons, :event_itens, :persons_products, :tip

  def initialize(name)
    @name = name
    @persons = []
    @event_itens = []
    @persons_products = []
    @tip = 0.0

    @log = Logger.new(STDOUT)
    @log.level = Logger::INFO
  end

  def add_item(name, price, item_count)
    product1 = Product.new(name, price)
    item1 = EventItem.new(product1, item_count)
    @event_itens.unshift(item1)
  end

  def add_person(name)
    p1 = Person.new(name)
    @persons.unshift(p1)
  end

  def add_person_product(person_name, share_type, share_value, product_description)
    #get person and the product
    person = @persons.find {|x| x.name == person_name}
    event_item = @event_itens.find {|x| x.product.description == product_description}
    product = event_item.product

    #add to the list
    person_product = PersonProduct.new(person, product, share_type, share_value)
    @persons_products.push(person_product)
  end

  def total
    acumulator = 0
    @event_itens.each do |event_itens|
      acumulator += event_itens.total
    end
    acumulator + acumulator
  end

  def tip_value
    @log.debug("Created logger")
    @log.warn("Created logger")
    @log.info("Program started")
    @log.error("Nothing to do!")
    @log.fatal("Nothing to do!")

    total * tip
  end

  def total_plus_tip
    total + tip_value
  end

  def total_person(person_name)
    person = @persons.find {|x| x.name == person_name}
    person.debt
  end

  def clear_all_debts
    #clear all old debts from each person
    @persons.each do |p1|
      p1.debt = 0
    end
  end

  def calculate_total
    clear_all_debts

    #iterates each product
    @event_itens.each do |event_item|
      product = event_item.product
      product_total_value = event_item.total

      #find_all person_product for this product
      persons_product = @persons_products.find_all do |x|
       x.product.description == product.description
      end

      #calculate total under this priority
       # 1 - value
       # 2 - quantity
       # 3 - proportion
       # 4 - equality

      #value
      pi_by_value = persons_product.find_all {|x| x.share_type == :value}
      pi_by_value.each do |p_item|
        p_item.person.debt += p_item.share_value
        product_total_value -= p_item.person.debt
      end

      #quantity
      pi_by_quantity = persons_product.find_all {|x| x.share_type == :quantity}
      pi_by_quantity.each do |p_item|
        p_item.person.debt += p_item.share_value * p_item.product.price
        product_total_value -= p_item.person.debt
      end

      #proportion
      pi_by_proportion = persons_product.find_all {|x| x.share_type == :proportion}
      pi_by_proportion.each do |p_item|
        p_item.person.debt += p_item.share_value * product_total_value
        product_total_value -= p_item.person.debt
      end

      #equality
      pi_by_equality = persons_product.find_all {|x| x.share_type == :equality}
      persons_sharing = pi_by_equality.count
      pi_by_equality.each do |p_item|
        p_item.person.debt += product_total_value / persons_sharing
      end
    end
  end

end

