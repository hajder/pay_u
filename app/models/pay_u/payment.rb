require 'resolv'

module PayU
  class Payment < ActiveRecord::Base
    attr_accessible :amount, :client_ip, :desc, :error_code, :fresh, :pay_type, :session_id, :status
    attr_accessor :ts
    
    belongs_to :payable, :polymorphic => true
    
    delegate :pos_id, :pos_auth_key, :key1, :key2, :to => PayU
    delegate :first_name, :last_name, :email, :to => :payable
    
    validates :amount, :client_ip, :desc, :presence => true
    validates :amount, :numericality => { :only_integer => true }
    validates :amount, :length => { :minimum => 3 } # Minimum payment is 100 groszy
    validates :client_ip, :format => { :with => Resolv::IPv4::Regex }
    
    before_create :generate_session_id
    
    MD5_ORDER = [:pos_id, :pay_type, :session_id, :pos_auth_key, :amount, :desc, :desc2, :trs_desc, :order_id, :first_name, :last_name, :payback_login, :street, :street_hn, :street_an, :city, :post_code, :country, :email, :phone, :language, :client_ip, :ts, :key1]
    
    def to_hash
      self.ts ||= Time.now.to_i
      hash = Hash.new
      MD5_ORDER.each do |key|
        next unless respond_to?(key)
        value = send(key)
        hash[key] = value unless value.nil?
      end
      hash.delete(:key1)
      hash[:sig] = full_sig
      hash
    end
    
    # Generates sig for new_payment
    def full_sig
      self.ts ||= Time.now.to_i
      str = MD5_ORDER.map {|key| respond_to?(key) ? send(key).to_s : '' }.join
      ::Digest::MD5.hexdigest(str)
    end
    
    # Generates sig for status check
    def short_sig
      self.ts ||= Time.now.to_i
      ::Digest::MD5.hexdigest(pos_id + session_id + ts.to_s + key1)
    end
    
    def generate_session_id
      self.session_id = ::Digest::MD5.hexdigest(pos_id + amount.to_s + first_name + last_name + Time.now.to_s)
    end
    protected :generate_session_id
    
  end
end
