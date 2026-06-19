class AddPaymentDestinationToOplata < ActiveRecord::Migration[8.1]
  def change
    add_column :oplata, :payment_destination, :string
  end
end
