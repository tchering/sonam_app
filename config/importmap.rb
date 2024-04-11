# Pin npm packages by running ./bin/importmap
# pin "@rails/ujs", to: "rails_ujs.js"
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap/dist/js/bootstrap.bundle.min.js"
pin "popper", to: "popper.js"
pin "bootstrap", to: "bootstrap.min.js", preload: true
