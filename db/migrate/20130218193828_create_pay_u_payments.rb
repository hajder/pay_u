class CreatePayUPayments < ActiveRecord::Migration
  def change
    create_table :pay_u_payments do |t|
      t.string :payable_type
      t.integer :payable_id
      t.string :session_id
      t.string :pay_type
      t.integer :amount
      t.string :client_ip
      t.boolean :fresh
      t.string :desc
      t.integer :status
      t.integer :error_code

      t.timestamps
    end
  end
end
