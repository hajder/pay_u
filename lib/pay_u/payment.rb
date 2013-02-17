module PayU
  class Payment
    attr_accessor :pay_type, :session_id, :amount, :desc, :desc2, :trs_desc, :order_id, :first_name, :last_name, :payback_login, :street, :street_hn, :street_an, :city, :post_code, :country, :email, :phone, :language, :client_ip, :ts
    attr_reader :pos_id, :pos_auth_key, :key1, :sig
    
    REQUIRED = [:pos_id, :session_id, :pos_auth_key, :amount, :desc, :first_name, :last_name, :email, :client_ip, :ts, :key1]
    
    MD5_ORDER = [:pos_id, :pay_type, :session_id, :pos_auth_key, :amount, :desc, :desc2, :trs_desc, :order_id, :first_name, :last_name, :payback_login, :street, :street_hn, :street_an, :city, :post_code, :country, :email, :phone, :language, :client_ip, :ts, :key1]
    
    def initialize(args = {})
      if args.is_a? Hash
        args.each do |key, value|
          send(key.to_s.concat('='), value)
        end
      end
      if session_id.nil?
        @session_id = ::Digest::MD5.hexdigest(pos_id + pos_auth_key + amount + first_name + last_name)
      end
    end
    
    def prepare
      calculate_sig(Time.now.to_i)
      self
    end
    
    def calculate_sig(ts)
      @ts = ts
      REQUIRED.each do |key|
        raise ::ArgumentError.new("Missing argument #{key}") if send(key) == nil
      end
      str = MD5_ORDER.map {|key| send(key).to_s }.join
      @sig = ::Digest::MD5.hexdigest(str)
    end
    
    def to_hash
      hash = Hash.new
      MD5_ORDER.each do |key|
        value = send(key)
        hash[key] = value unless value.nil?
      end
      hash.delete(:key1)
      hash[:sig] = @sig
      hash
    end
    
    def payment_url
      PayU.payment_url + '/?' + to_hash.to_query
    end
    
    def status_url
      @ts = Time.now.to_i
      _sig = ::Digest::MD5.hexdigest(pos_id + @session_id + @ts.to_s + key1)
      PayU.status_url + "/?pos_id=#{pos_id}&session_id=#{session_id}&sig=#{_sig}&ts=#{@ts}"
    end
    
    def pos_id
      PayU.pos_id.to_s
    end
    
    def pos_auth_key
      PayU.pos_auth_key
    end
    
    def key1
      PayU.key1
    end
    
    def key2
      PayU.key2
    end
  
  end
end