class UpdateTransactionCcType < ActiveRecord::Migration[5.1]
  def change
    change_column :transactions, :credit_card_number, :bigint
  end
end
