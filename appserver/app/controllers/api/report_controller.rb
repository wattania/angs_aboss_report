class Api::ReportController < ApiBaseController
  def index
    render json: { error: nil}
  end
end
