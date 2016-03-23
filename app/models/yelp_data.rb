require 'yelp'
class YelpData < ActiveRecord::Base

  def self.add_studios(lat, lng)
    # coordinates = { latitude: 47.6097, longitude: -122.3331 }
    coordinates = { latitude: lat, longitude: lng }
    info = { term: 'dance',
             sort: 2,
             category_filter: 'dance_schools,dancestudio',
    }
    result = Yelp.client.search_by_coordinates(coordinates, info)
    result.businesses.each do |studio|
      st          = Studio.new
      st.name     = studio.name
      st.street   = studio.location.address[0]
      st.city     = studio.location.city
      st.state    = studio.location.state_code
      st.zip_code = studio.location.postal_code
      st.lat      = studio.location.coordinate.latitude
      st.lng      = studio.location.coordinate.longitude
      st.save
    end
  end

end
