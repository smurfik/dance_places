class StudiosController < ApplicationController

  def index
    @studios = Studio.where(lat: 47, lng: -122)
    # @studios = Studio.where.not(facebook_id: nil)
  end

end
