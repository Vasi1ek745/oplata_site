# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
# config/importmap.rb
pin "custom/refresh_button", to: "custom/refresh_button.js"


pin "controllers/dashboard_controller", to: "controllers/dashboard_controller.js"
pin "controllers/payment_controller", to: "controllers/payment_controller.js"