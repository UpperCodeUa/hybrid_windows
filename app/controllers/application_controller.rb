class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Localable
  include TurboFlashable
  include Pagy::Backend
  include Rectify::ControllerHelpers
end
