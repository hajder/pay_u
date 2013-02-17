require_dependency "pay_u/application_controller"

module PayU
  class PaymentsController < ApplicationController
    def positive
      
    end
    
    def negative
      
    end
    
    def report
      unless sig_valid?
        raise ArgumentError.new('Invalid sig')
      end
      SuckerPunch::Queue[:payu_status_queue].async.perform(params[:session_id])
      
      render :text => 'ok'
    end
    
    protected
    
    def sig_valid?
      my_sig = ::Digest::MD5.hexdigest( PayU.pos_id + params[:session_id] + params[:ts] + PayU.key2 )
      my_sig == params[:sig]
    end
  end
end
