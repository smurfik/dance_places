$(document).ready(function() {
  // $('.city')
  // var geocoder = new google.maps.Geocoder();
  // console.log($('.city').text());
  // console.log(geocoder.geocode({address: $('.city').text()}));

  // get ajax request
  // https://maps.googleapis.com/maps/api/geocode/json?address=Seattle&key=GOOGLE_API_KEY
  $.get("/search_google", {
    city: $('.city').text()
    }, function(data) {
      $('.city').html(data.address)
      console.log($("h1"));
      // console.log(data);
  });

});
