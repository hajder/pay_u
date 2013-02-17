class PayUStatus
  include SuckerPunch::Worker

  def perform(session_id)
    ActiveRecord::Base.connection_pool.with_connection do
      Payment.update_status!(session_id)
    end
  end
end