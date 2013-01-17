class PersonItem
  attr_accessor :person, :item, :share_type, :share_value

  def initialize(person, item)
    @person = person
    @item = item
    @share_type = :value
    @share_value = 0
  end

end
