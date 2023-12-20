class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    # Customize the redirect path after sign in
    def after_sign_in_path_for(resource)
        links_path
    end

    # Update the strong parameters to allow/support 'username'
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end
end
