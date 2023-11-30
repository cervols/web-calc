Rails.application.routes.draw do
  root "api/v1/operations#result"

  match "*unmatched", to: "application#not_found", via: :all
end
