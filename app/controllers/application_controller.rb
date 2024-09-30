class ApplicationController < ActionController::Base
  UnauthorizedError = Class.new(StandardError)

  rescue_from UnauthorizedError, with: :unauthorized_response

  private

  def unauthorized_response
    render body: nil, status: 403
  end
end
