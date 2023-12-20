class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    def create
        super do |resource|
          # Your custom logic after a user is created
          resource.update(username: params[:user][:username])
        end
    end

    # Update the strong parameters to allow/support 'username'
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end
end
