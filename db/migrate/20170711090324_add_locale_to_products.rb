class AddLocaleToProducts < ActiveRecord::Migration[5.1]
  def up
    add_column :products, :locale, :string
  end
  def down
    remove_column :products, :locale, :string
  end
end
