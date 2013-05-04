require 'active_support/core_ext'
require 'active_support/inflector'
require 'i18n'

require 'pay_u/engine'
require 'pay_u/error'
require 'pay_u/status'
require 'pay_u/payment_status'
require 'pay_u/railtie' if defined?(Rails)

module PayU
  mattr_accessor :service_url
  @@service_url = 'https://www.platnosci.pl/paygw'
  
  mattr_accessor :encoding
  @@encoding = 'UTF'
  
  mattr_accessor :new_payment_path
  @@new_payment_path = 'NewPayment'
  
  mattr_accessor :status_path
  @@status_path = 'Payment/get'
  
  mattr_accessor :pos_id
  @@pos_id = nil
  
  mattr_accessor :pos_auth_key
  @@pos_auth_key = nil
  
  mattr_accessor :key1
  @@key1 = nil
  
  mattr_accessor :key2
  @@key2 = nil
  
  def self.new_payment_url
    @@service_url + '/' + @@encoding + '/' + @@new_payment_path
  end
  
  def self.status_url
    @@service_url + '/' + @@encoding + '/' + @@status_path
  end

  def self.setup
    yield self
  end
  
  module ClassMethods
    def has_payment
      class_eval do
        has_one :payment, :as => :payable, :class_name => 'PayU::Payment'
        accepts_nested_attributes_for :payment
        attr_accessible :payment_attributes
        
        def self.find_by_payment_session_id(session_id)
          PayU::Payment.find_by_session_id(session_id).payable
        end
      end
    end
  end

end
