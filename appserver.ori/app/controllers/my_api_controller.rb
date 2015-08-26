class MyApiController < ApplicationController
  def index
    render json: { success: true }
  end
end
