module PayU
  module Payable
    def included(base)
      base.send(:has_one, Payment)
      Payment.send(:belongs_to, base)
    end
  end
end
