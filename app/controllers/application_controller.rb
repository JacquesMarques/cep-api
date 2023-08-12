# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::API
  include Authentication
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  protected

  def builder_error(error)
    render status: 400, json: {
      error: {
        type: error.class,
        message: error.message,
        invalid_params: error.invalid_params
      }
    }
  end

  def unprocessable_entity(resource, errors = nil)
    render status: :unprocessable_entity, json: {
      error: {
        message: "Invalid parameters for resource #{resource.class}.",
        invalid_params: errors || resource.errors
      }
    }
  end

  def orchestrate_query(scope, actions = :all)
    QueryOrchestrator.new(scope:,
                          params:,
                          request:,
                          response:,
                          actions:).run
  end

  def serialize(data, options = {})
    {
      json: Api::Serializer.new(data:,
                                params:,
                                actions: %i[fields embeds],
                                options:).to_json
    }
  end

  private

  def resource_not_found
    render(status: 404)
  end
end
