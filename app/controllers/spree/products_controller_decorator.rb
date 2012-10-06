Spree::ProductsController.class_eval do
  def index
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products

    if request.xhr?
      render :partial => 'spree/shared/product', :collection => @products 
    else
      respond_with(@products)
    end
  end

  def show
    @product = Spree::Product.active.find_by_permalink!(params[:id])
    return unless @product

    @variants = Spree::Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
    @product_properties = Spree::ProductProperty.includes(:property).where(:product_id => @product.id)

    referer = request.env['HTTP_REFERER']

    if referer && referer.match(HTTP_REFERER_REGEXP)
      @taxon = Spree::Taxon.find_by_permalink($1)
      load_special_products(@taxon)
    end

    respond_with(@product)
  end
end
