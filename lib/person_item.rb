class PersonItem
  attr_accessor :person, :item, :count

  def initialize(person, item)
    @person = person
    @item = item
    @count = 0.0
  end

  def total
    return @item.product.price * @count
  end

end
