class Event
  attr_accessor :name, :place, :persons, :products

  def initialize(name)
    @name = name
    @persons = []
    @products = []
  end
end
