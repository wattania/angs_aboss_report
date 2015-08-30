class Webapp::HomeController < WebappBaseController
  def index
    render json: { error: nil}
  end
end