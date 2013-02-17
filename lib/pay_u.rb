require 'active_support/core_ext'
require 'active_support/inflector'
require 'i18n'
require 'pry'
require 'pay_u/engine'

module PayU
  mattr_accessor :service_url
  @@service_url = 'https://www.platnosci.pl/paygw'
  
  mattr_accessor :encoding
  @@encoding = 'UTF'
  
  mattr_accessor :payment_path
  @@payment_path = 'NewPayment'
  
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
  
  def self.payment_url
    @@service_url + '/' + @@encoding + '/' + @@payment_path
  end
  
  def self.status_url
    @@service_url + '/' + @@encoding + '/' + @@status_path
  end

  def self.setup
    yield self
  end

end
