class PersonProductAgregator
  def initialize(person_products)
    @person_products = person_products
  end

  def total(product_description, share_type)
    person_products_by_share_type = @person_products.find_all do |pp|
      pp.product.description == product_description &&
      pp.share_type == share_type
    end

    if (share_type == :quantity || share_type == :value)
      acumulator = 0
      person_products_by_share_type.each do |pp_share_type|
        acumulator += pp_share_type.share_value
      end
      return acumulator
    end

    if (share_type == :proportion)
      last_one = person_products_by_share_type.last
      return last_one.share_value unless last_one.nil?
    end

    return 0
  end

end
