PayU::Engine.routes.draw do
  match '/payment-positive/:session_id/:error_code' => 'payments#positive'
  match '/payment-negative/:session_id/:error_code' => 'payments#negative'
  match '/payment-report' => 'payments#report'
end
