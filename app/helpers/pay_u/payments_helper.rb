module PayU
  module PaymentsHelper
    def pay_u_new_payment_url(payment)
      PayU.new_payment_url + '/?' + payment.to_hash.to_query
    end
    
    def pay_u_payment_status_url(payment)
      PayU::PaymentStatus.url(payment)
    end
  end
end
