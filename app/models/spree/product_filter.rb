module Spree
  class ProductFilter < ActiveRecord::Base
    belongs_to :taxon
    belongs_to :property
    
    validates :taxon, :title, :property, :presence => true

    scope :indexed, where('indexed_at IS NOT NULL AND updated_at IS NOT NULL AND indexed_at >= updated_at')

    def indexed?
      indexed_at && updated_at && indexed_at >= updated_at
    end

    def extract_data(product)
      product_property = product.product_properties.
        where(:property_id => property.id).first
      return {} unless product_property

      { property.id.to_s => product_property.value }
    end

    def apply(searcher, params)
      filter = self
      name = "filter_#{id}"
      searcher.dynamic :property do
        options = { :name => name }
        if !searcher.params[name].blank?
          conditions = any_of do
            Array(searcher.params[name]).each do |value|
              with(filter.property.id.to_s, value)
            end
          end
          options[:exclude] = [conditions]
        end

        facet filter.property.id, options
      end
    end

    private

    def reindex_products
      taxon.reindex_products
    end
  end
end
