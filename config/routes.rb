PayU::Engine.routes.draw do
  match '/payment-positive/:session_id/:error_code' => 'payments#positive', via: :all
  match '/payment-negative/:session_id/:error_code' => 'payments#negative', via: :all
  match '/payment-report' => 'payments#report', via: :all
end
