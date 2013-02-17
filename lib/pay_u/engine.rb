require 'sucker_punch'

module PayU
  class Engine < ::Rails::Engine
    isolate_namespace PayU
  end
end
