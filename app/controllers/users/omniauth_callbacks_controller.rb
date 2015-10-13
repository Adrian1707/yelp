class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])
      puts "Before IF statement"
      if @user.persisted?
      puts "Inside IF statement"
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
      puts "Inside else statement"
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
      puts @user.errors.to_a
    end

end
