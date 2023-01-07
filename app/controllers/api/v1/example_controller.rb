# frozen_string_literal: true

class Api::V1::ExampleController < Api::AppController
  def index
    @users = User.select('id, email')
    render json: @users
  end
end
