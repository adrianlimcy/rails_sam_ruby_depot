class AddPrice < ActiveRecord::Migration[5.0]
  def up
    add_column :line_items, :price, :decimal, precision: 8, scale: 2, default: 0.01

    LineItem.all.each do |lineItem|
      lineItem.update_attribute :price, lineItem.product.price
    end
  end
  def down
    remove_column :line_items, :price
  end
end
