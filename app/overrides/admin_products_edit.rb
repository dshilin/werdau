Deface::Override.new(:virtual_path  => "spree/admin/products/_form",
                     :insert_bottom => "div[data-hook='admin_product_form_right']",
                     :name          => "popular",
                     :text          => '<p>
  <%= f.check_box :popular %>
  <%= f.label :popular, t(".popular") %>
</p>')

Deface::Override.new(:virtual_path  => "spree/admin/products/_form",
                     :insert_bottom => "div[data-hook='admin_product_form_right']",
                     :name          => "best",
                     :text          => '<p>
  <%= f.check_box :best %>
  <%= f.label :best, t(".best") %>
</p>')
