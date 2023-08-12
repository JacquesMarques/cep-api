class CreateZipAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :zip_accesses do |t|
      t.string :zipcode
      t.string :state
      t.string :city
      t.string :neighborhood
      t.string :street
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
