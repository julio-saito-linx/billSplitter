class EventItem

  attr_accessor :count, :product

  def initialize(product, count)
    @product = product
    @count = count
  end

  def add(quantity)
    @count += quantity
  end

  def total
    @count * @product.price
  end

end
