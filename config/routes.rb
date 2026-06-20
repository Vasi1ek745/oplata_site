Rails.application.routes.draw do
  root "oplata#index"
  get "up" => "rails/health#show", as: :rails_health_check
  resources :oplata do
    collection do 
      get :refresh_data
      get :manual_refresh
      get :recently_paid
      get :dashboard
      get :dashboard_data  # Новый маршрут для получения данных по месяцам
    end
    member do 
      patch :mark_as_paid
    end
  end
  
  get "pdf_create", to: "pdf_create#index"
  post "pdf_create/generate", to: "pdf_create#generate"
  delete "pdf_create/cleanup", to: "pdf_create#cleanup", as: :pdf_create_cleanup
end