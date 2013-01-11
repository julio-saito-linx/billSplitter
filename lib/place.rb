class Place
  attr_accessor :name, :products

  def initialize(name)
    @name = name
    @products = []
  end
end
