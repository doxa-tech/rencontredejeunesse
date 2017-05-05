class Api::MarkersController < Api::BaseController

  def index
    @markers = Marker.all
  end
end
