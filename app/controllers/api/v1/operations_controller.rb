class Api::V1::OperationsController < ApplicationController
  before_action :restrict_access

  EXPRESSION_REGEXP = /\d+([-+*\/]{1}\d+)+/

  def result
    secure_expression_string = EXPRESSION_REGEXP.match(expression_params).to_s

    result = eval(secure_expression_string)

    render json: {
      expression: secure_expression_string,
      result: result
    }, status: :ok

  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  end

  private

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        ApiKey.exists?(access_token: token)
      end
    end

    def expression_params
      params.require(:expression)
    end
end
