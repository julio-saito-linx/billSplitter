require 'util/simple_logger'
require 'eventItem'
require 'product'
require 'person'

class Event
  attr_accessor :name, :persons, :event_itens, :persons_products, :tip

  def initialize(name)
    @name = name
    @persons = []
    @event_itens = []
    @persons_products = []
    @tip = 0.0

    SimpleLogger.new(STDOUT, Logger::INFO)
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
    $log.info("  ------------")
    $log.info("  total()")

    accumulator = 0
    @event_itens.each do |event_itens|
      accumulator += event_itens.total
      $log.info("    #{event_itens.total}  -  #{event_itens.product.description}")
    end
    $log.info("    --------")
    $log.info("    #{accumulator}  -  total")
    $log.info("  ------------")
    accumulator
  end

  def tip_value
    (total * tip).round(2)
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
    $log.info("calculate_total()")
    clear_all_debts

    #iterates each product
    @event_itens.each do |event_item|
      $log.info("------------------")
      $log.info("product = #{event_item.product.description}")
      product = event_item.product

      $log.info("  product_total_value = #{event_item.total}")
      product_total_value = event_item.total

      #find_all person_product for this product
      persons_product = @persons_products.find_all do |x|
        x.product.description == product.description
      end

      # calculate total with this priority:
      # 1-value, 2-quantity, 3-proportion, 4-equality

      product_total_value -= calculate_total_by(:value, persons_product, product_total_value)
      product_total_value -= calculate_total_by(:quantity, persons_product, product_total_value)
      product_total_value -= calculate_total_by(:proportion, persons_product, product_total_value)
      product_total_value -= calculate_total_by(:equality, persons_product, product_total_value)

      $log.info("                  (=) = #{product_total_value}") unless product_total_value == event_item.total

    end

  end

  def calculate_total_by(share_type, persons_product, product_total_value)
    total_for_this_share_type = 0
    #value
    pp_share = persons_product.find_all {|x| x.share_type == share_type}
    pp_share.each do |p_item|
      case
      when share_type == :value
        total_for_this_share_type = p_item.share_value
      when share_type == :quantity
        total_for_this_share_type = p_item.share_value * p_item.product.price
      when share_type == :proportion
        total_for_this_share_type = p_item.share_value * product_total_value
      when share_type == :equality
        total_for_this_share_type = product_total_value / pp_share.count
      end

      $log.info("                  (-) = #{total_for_this_share_type}  #{p_item.person.name} (#{share_type})")
      p_item.person.debt += total_for_this_share_type
    end

    $log.info("                  (=) = #{product_total_value - total_for_this_share_type}") unless pp_share.empty?
    return total_for_this_share_type
  end

end

