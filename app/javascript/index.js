import { application } from "controllers/application"
import budgetController from "./budget_controller"

application.register("budget", budgetController)
