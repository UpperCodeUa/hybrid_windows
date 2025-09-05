class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :requests do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
