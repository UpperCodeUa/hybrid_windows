module ControllerMacros
  def login_user(user)
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end
end
