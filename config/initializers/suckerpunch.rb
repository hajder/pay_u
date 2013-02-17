SuckerPunch.config do
  queue name: :payu_status_queue, worker: PayUStatus, size: 100
end