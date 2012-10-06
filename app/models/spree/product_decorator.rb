Spree::Product.class_eval do
  reflect_on_association(:product_properties).options[:order] = 'position asc'

  def to_param
    permalink.present? ? permalink : (permalink_was || name.to_s.to_url.gsub("'", ''))
  end

  scope :with_no_images, where("(select count(*) from spree_assets where type = 'Spree::Image' and viewable_type = 'Spree::Product' and viewable_id = spree_products.id) = 0")
  scope :with_no_properties, where("(select count(*) from spree_product_properties where product_id = spree_products.id) = 0")

  scope :cheapest, joins(:variants_with_only_master).group('spree_variants.price').having('min(spree_variants.price)').limit(1)
  scope :only_best, where(:best => true)
  scope :only_popular, where(:popular => true)

  search_methods :with_no_images, :with_no_properties

  def rating
    stars.to_f
  end

  searchable do
    text :name
    string :name, :stored => true
    float :price, :stored => true
    float :rating, :stored => true

    date :available_on
    date :deleted_at

    integer :taxon_ids, :multiple => true

    dynamic_string :"property", :stored => true do
      filters = taxons.collect { |t| t.product_filters }.flatten
      filters.inject({}) do |fields,filter|
        fields.merge(filter.extract_data(self))
      end
    end
  end
end

