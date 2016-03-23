require 'yelp'
class SearchData < ActiveRecord::Base

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
      facebook_studio = get_studio(studio)
      if facebook_studio != "Error"
        st          = Studio.new
        st.name     = studio.name
        st.street   = studio.location.address[0]
        st.city     = studio.location.city
        st.state    = studio.location.state_code
        st.zip_code = studio.location.postal_code
        st.lat      = studio.location.coordinate.latitude
        st.lng      = studio.location.coordinate.longitude
        st.facebook_id = facebook_studio["id"]
        st.save
        add_website_and_image(st, facebook_studio["id"])
      end
    end
  end

  def self.get_studio(studio)
    @graph.get_object(studio.name.gsub(/\s+|'|:/, ""))
  rescue URI::InvalidURIError, Koala::Facebook::ClientError => e
    "Error"
  end

  def self.add_website_and_image(studio, facebook_id)
    url = @graph.get_connections(facebook_id, "?fields=website")
    studio.update(url: url["website"].split[0]) unless !url["website"].present?
    image = @graph.get_connections(facebook_id, "?fields=photos{album,images}")
    studio.update(image: image["photos"]["data"][0]["images"][0]["source"]) unless !image["photos"]["data"][0]["images"][0]["source"].present?
  end

end
