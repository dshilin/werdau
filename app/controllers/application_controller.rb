class ApplicationController < ActionController::Base

  def forem_user
    current_user
  end
  helper_method :forem_user

  protect_from_forgery

  cache_sweeper :taxon_sweeper

  private

  def load_special_products(taxon)
    return if taxon.nil?

    products = taxon.products
    @cheapest = products.cheapest.first
    @best = products.only_best.first
    @popular = products.only_popular.first
  end
end
