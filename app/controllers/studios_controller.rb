class StudiosController < ApplicationController

  def index
    @studios = Studio.where(lat: 47.6097, lng: -122.3331)
  end

end
