class CreatePayUPayments < ActiveRecord::Migration
  def up
    create_table :pay_u_payments do |t|
      t.string :payable_type
      t.integer :payable_id
      t.string :session_id
      t.string :pay_type
      t.integer :amount
      t.string :client_ip
      t.string :desc
      t.string :status
      t.string :error

      t.timestamps
    end
  end
  
  def down
    drop_table :pay_u_payments
  end
end
