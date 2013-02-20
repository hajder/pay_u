module PayU
  module Status
    
    STATUS_CODES_MAP = {
      1 => :new,
      2 => :cancelled,
      3 => :refused,
      4 => :started,
      5 => :waiting,
      7 => :chargeback,
      99 => :finished,
      888 => :exception
    }
    
    def translate_status!
      @status_code = @status.to_i
      @status = STATUS_CODES_MAP[@status_code]
    end
  end
end