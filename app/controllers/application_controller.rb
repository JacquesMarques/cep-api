# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::API
  include Authentication
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  private

  def resource_not_found
    render(status: 404)
  end
end
