$(document).ready(function() {

  var $grid = $('.grid').masonry({
    itemSelector: '.grid-item',
  });

  $('img').on('load', function() {
    $grid.masonry('reloadItems')
    $grid.masonry('layout');
  });

  $('button#city-btn').click( function(e) {
    e.preventDefault();
    var query = $('input#city').val() || "Seattle";
    $(".wrapper").css("display", "block");

    $.get("/search_google", {
      city: query
      }, function(data) {
        $('h1').html("Studios in " + data.address);
        $grid.empty();
        $grid.masonry('destroy')

        var url, html, studio;
        var elements = [];

        for(var i=0; i < data.studios.length; i++) {
          studio = data.studios[i]
          url = ""
          if (data.studios[i].url){
            url = '<div><a href="'+ data.studios[i].url + '">Studio Website</a></div>';
          }
          html = '<li class="grid-item"><div class="studio-name">'
                 + studio.name
                 + '</div><a href="'
                 + studio.facebook_link
                 + '"><img src="'
                 + studio.image
                 + '"/></a>'
                 + url
                 + '<div>'
                 + studio.street
                 + '</div><div>'
                 + studio.city
                 + ', '
                 + studio.state
                 + ' '
                 + studio.zip_code
                 + '</div></li>'

          elements.push($(html));
        }
        $grid.append(elements);

        $('img').on('load', function() {
          $('.grid').masonry({
            itemSelector: '.grid-item',
          });
        });

      });

      $(document).ajaxStop(function() {
        $(".wrapper").css("display", "none");
      });

  });
});
