// app/javascript/controllers/index.js
import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Автоматически загружает все контроллеры из папки controllers
eagerLoadControllersFrom("controllers", application)