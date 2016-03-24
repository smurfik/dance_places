class SearchController < ApplicationController

  def search_google
    info = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{params[:city]}&key=#{ENV["GOOGLE_API_KEY"]}", verify:  false).parsed_response
    pretty_looking_address = info["results"][0]["formatted_address"]
    latitude = info["results"][0]["geometry"]["location"]["lat"]
    longitude = info["results"][0]["geometry"]["location"]["lng"]
    @studios = Studio.where(lat: latitude, lng: longitude)
    if @studios == []
      me = "here"
      SearchData.add_studios(latitude, longitude)
      studios = Studio.where(lat: latitude, lng: longitude)
      render json: {
        lat: latitude,
        lng: longitude,
        address: pretty_looking_address,
        studios: studios
      }
    else
      render json: {
        address: pretty_looking_address,
        studios: @studios
      }
    end
  end

end
