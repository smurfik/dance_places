class StudiosController < ApplicationController

  def index
    @studios = Studio.where(lat: 47, lng: -122)
  end

end
