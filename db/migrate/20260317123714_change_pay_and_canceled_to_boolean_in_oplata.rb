# db/migrate/XXXXXX_change_pay_and_canceled_to_boolean_in_oplata.rb
class ChangePayAndCanceledToBooleanInOplata < ActiveRecord::Migration[8.1]
  def up
    # Изменяем тип поля pay на boolean
    change_column :oplata, :pay, :boolean, default: false, null: false
    
    # Изменяем тип поля canceled на boolean
    change_column :oplata, :canceled, :boolean, default: false, null: false
  end

  def down
    # Откат миграции - возвращаем обратно к исходному типу
    # Предположим, что исходный тип был integer (0/1)
    change_column :oplata, :pay, :integer, default: 0, null: false
    change_column :oplata, :canceled, :integer, default: 0, null: false
  end
end