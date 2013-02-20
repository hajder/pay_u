require 'open-uri'
require 'pay_u/status'

module PayU
  class PaymentStatus
    include PayU::Status
    
    attr_reader :id, :status, :status_code, :pay_type, :create, :init, :sent, :recv, :cancel
        
    def self.url(payment)
      PayU.status_url + "/?pos_id=#{payment.pos_id}&session_id=#{payment.session_id}&sig=#{payment.short_sig}&ts=#{payment.ts}"
    end
    
    def initialize(payment)
      @payment = payment
      doc = Nokogiri::XML(open(self.class.url(@payment)))
      parse(doc)
      translate_status!
    end
    
    def parse(doc)
      if doc.xpath('/response/status').inner_text != 'OK'
        raise "Invalid response: #{doc.xpath('/response/status').inner_text}, OK expected"
      end

      doc.xpath('/response/trans').children.each do |child|
        next if child.is_a?(Nokogiri::XML::Text)
        instance_eval("@#{child.name} = '#{child.inner_text}'")
      end
    end
  end
end