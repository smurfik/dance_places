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

  def add_website
    @graph = Facebook.graph
    @studios = Studio.where.not(facebook_id: nil)
    arr = []
    @studios.each do |studio|
      url = @graph.get_connections(studio.facebook_id, "?fields=website")
      studio.update_attribute(:url, url["website"].split[0]) unless !url["website"].present?
      image = @graph.get_connections(studio.facebook_id, "?fields=photos{album,images}")
      studio.update_attribute(:image, image["photos"]["data"][0]["images"][0]["source"]) unless !image["photos"]["data"][0]["images"][0]["source"].present?
      # image = @graph.get_connections(studio.facebook_id, "?fields=picture{url}")
      # studio.update_attribute(:image, image["picture"]["data"]["url"]) unless !image["picture"]["data"]["url"].present?
    end
    raise
  end

  def get_studio(studio)
    @graph.get_object(studio.name.gsub(/\s+|'|:/, ""))
  rescue URI::InvalidURIError, Koala::Facebook::ClientError => e
    "Error"
  end

end
