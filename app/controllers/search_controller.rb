class SearchController < ApplicationController

  def search_google
    info = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{params[:city]}&key=#{ENV["GOOGLE_API_KEY"]}", verify:  false).parsed_response
    pretty_looking_address = info["results"][0]["formatted_address"]
    latitude = info["results"][0]["geometry"]["location"]["lat"]
    longitude = info["results"][0]["geometry"]["location"]["lng"]
    YelpData.add_studios(latitude, longitude)
    studios = Studio.where(lat: latitude, lng: longitude)
    render json: {
      lat: latitude,
      lng: longitude,
      address: pretty_looking_address,
      studios: studios
    }
  end

  def facebook
    @studios = Studio.all
    @graph = Facebook.graph
    @studios.each do |studio|
      id = get_studio(studio)
      studio.update_attribute(:facebook_id, id["id"]) unless id == "Error"
    end
    raise
  end

  def get_studio(studio)
    @graph.get_object(studio.name.gsub(/\s+|'|:/, ""))
  rescue URI::InvalidURIError, Koala::Facebook::ClientError => e
    "Error"
  end

end
