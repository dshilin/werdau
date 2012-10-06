class AddPopularAndBestFlagsToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :popular, :boolean
    add_column :spree_products, :best, :boolean

    add_index :spree_products, :popular
    add_index :spree_products, :best
  end
end
