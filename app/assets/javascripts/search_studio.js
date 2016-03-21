$(document).ready(function() {
  $('button#city_btn').click( function(e) {
    e.preventDefault();
    var query = $('input#city').val() || "Seattle";

    $.get("/search_google", {
      city: query
      }, function(data) {
        $('h1').html("The list of studios in " + data.address)
    });
  });
});
