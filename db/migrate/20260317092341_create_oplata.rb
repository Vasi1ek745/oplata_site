class CreateOplata < ActiveRecord::Migration[8.1]
  def change
    create_table :oplata do |t|
      t.string :name
      t.string :date
      t.integer :pay
      t.integer :canceled
      t.float :duration

      t.timestamps
    end
  end
end
