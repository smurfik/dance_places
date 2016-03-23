require 'yelp'
class YelpData < ActiveRecord::Base

  def self.add_studios(lat, lng)
    @graph = Facebook.graph
    # coordinates = { latitude: 47.6097, longitude: -122.3331 }
    coordinates = { latitude: lat, longitude: lng }
    info = { term: 'dance',
             sort: 2,
             category_filter: 'dance_schools,dancestudio',
    }
    result = Yelp.client.search_by_coordinates(coordinates, info)
    result.businesses.each do |studio|
      id = get_studio(studio)
      if id != "Error"
        st          = Studio.new
        st.name     = studio.name
        st.street   = studio.location.address[0]
        st.city     = studio.location.city
        st.state    = studio.location.state_code
        st.zip_code = studio.location.postal_code
        st.lat      = studio.location.coordinate.latitude
        st.lng      = studio.location.coordinate.longitude
        st.facebook_id = id["id"]
        st.save
        add_website_image(st, id["id"])
      end
    end
  end

  def self.get_studio(studio)
    @graph.get_object(studio.name.gsub(/\s+|'|:/, ""))
  rescue URI::InvalidURIError, Koala::Facebook::ClientError => e
    "Error"
  end

  def self.add_website_image(studio, facebook_id)
    url = @graph.get_connections(facebook_id, "?fields=website")
    studio.update_attribute(:url, url["website"].split[0]) unless !url["website"].present?
    image = @graph.get_connections(facebook_id, "?fields=photos{album,images}")
    studio.update_attribute(:image, image["photos"]["data"][0]["images"][0]["source"]) unless !image["photos"]["data"][0]["images"][0]["source"].present?
    # image = @graph.get_connections(studio.facebook_id, "?fields=picture{url}")
    # studio.update_attribute(:image, image["picture"]["data"]["url"]) unless !image["picture"]["data"]["url"].present?
  end

end
