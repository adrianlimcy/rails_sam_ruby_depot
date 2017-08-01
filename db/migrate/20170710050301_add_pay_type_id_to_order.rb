class AddPayTypeIdToOrder < ActiveRecord::Migration[5.1]
  def up
    add_column :orders, :pay_type_id, :integer
    remove_column :orders, :pay_type
  end

  def down
    add_column :orders, :pay_type, :string
    remove_column :orders, :pay_type_id
  end
end
