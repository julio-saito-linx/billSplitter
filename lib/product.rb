class Product
  attr_accessor :description, :unit_price

  def initialize(description)
    @description = description
    @unit_price = 0
  end
end
