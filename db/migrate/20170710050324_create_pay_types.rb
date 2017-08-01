class CreatePayTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :pay_types do |t|
      t.string :name

      t.timestamps
    end
      
  end
end
