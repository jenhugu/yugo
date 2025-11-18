class ApplicationController < ActionController::Base
  # helper_method :test_current_user
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Ne pas appeler le User.first dans une méthode current_user car ça fait péter la navbar
  # Je pense une méthode test_current pourrait fonctionner

  # def test_current_user
  #  User.first # TEMP pour les tests
  # end

  protected

  def configure_permitted_parameters
    # Pour le sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])

    # Pour le account update si besoin après
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
