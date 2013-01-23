class PersonProduct
  attr_accessor :person, :product, :share_type, :share_value

  def initialize(person, product, share_type, share_value)
    @person = person
    @product = product
    @share_type = share_type
    @share_value = share_value
  end

end
