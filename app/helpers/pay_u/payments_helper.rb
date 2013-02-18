module PayU
  module PaymentsHelper
    def pay_u_new_payment_url(payment)
      PayU.new_payment_url + '/?' + payment.to_hash.to_query
    end
    
    def pay_u_payment_status_url(payment)
      PayU.status_url + "/?pos_id=#{payment.pos_id}&session_id=#{payment.session_id}&sig=#{payment.short_sig}&ts=#{payment.ts}"
    end
  end
end
