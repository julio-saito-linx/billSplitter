class Product
  attr_accessor :description, :unit_price

  def initialize(description, unit_price)
    @description = description
    @unit_price = unit_price
  end
end
