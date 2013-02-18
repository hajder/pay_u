require 'pay_u'

module PayU
  require 'rails'

  class Railtie < Rails::Railtie
    initializer 'pay_u.insert_into_active_record' do |app|
      ActiveSupport.on_load :active_record do
        PayU::Railtie.insert
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(ActiveRecord)
        ActiveRecord::Base.extend PayU::ClassMethods
      end
    end
  end
end