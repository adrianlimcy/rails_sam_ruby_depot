class AddShipDateToOrder < ActiveRecord::Migration[5.1]
  def up
    add_column :orders, :ship_date, :date
  end

  def down
    remove_column :orders, :ship_date
  end
end
