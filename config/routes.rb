Rails.application.routes.draw do
  scope "(:locale)", locale: /(#{I18n.available_locales.map(&:to_s).join('|')})/ do
    root "home#index"

    get "catalog",           to: "home#catalog"
    get "calculator",        to: "home#calculator"
    get "contacts",          to: "home#contacts"
    post "/contacts",        to: "home#create_request"
    get "products",          to: "home#products"
    get "product-page",      to: "home#product_page"
    get "alu-patio",         to: "home#alu_patio"
    get "alue-passive",      to: "home#alue_passive"
    get "alu-style",         to: "home#alu_style"
    get "alu-glass",         to: "home#alu_glass"
    get "glass",             to: "home#glass"
    get "blinds",            to: "home#blinds"
    get "alu-passive-doors", to: "home#alu_passive_doors"
    get "thank-you-request", to: "home#thankyou_request"

    devise_for :users
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  mount MissionControl::Jobs::Engine, at: "/jobs"
end
