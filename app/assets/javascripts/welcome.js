"use strict";

$('document').ready(function(){
  // thisMonthsScreenings();
  addBuzzBoxPosterListener();
});


function addBuzzBoxPosterListener(){
  $('div.thumbnail').hover(
    function(){
      $( this ).find('.overlay').fadeIn( 500 );
    },
    function(){
      $( this ).find('.overlay').fadeOut( 500 );
    })
}


function addScreeningsToCalendar(screenings){
  for (var key in screenings){
    console.log(key);
    for(var i = 0; i < screenings[key].length; i++){
      var movie = screenings[key][i].movie;
      var showtimeHtml = screenings[key][i].showtime_html;
      var theater = screenings[key][i].theater;
      var url = screenings[key][i].ticketing_url

      console.log(movie);
      console.log(showtimeHtml);
      console.log(theater);
      $("td#td"+key).append("<br><span class='film-title'>"+movie+"</span><br>"+showtimeHtml+"<br><span class='theater-name'>"+theater+"</span>");
    }
  }
  addPlaceholderToEmptyDays();
}

function addPlaceholderToEmptyDays(){
  $('td span.date:last-child').parent().append("<br><span class='placeholder hidden-sm hidden-md hidden-lg hidden-xl'>no screenings</span>")
}


function thisMonth(){
 var month = $('table')[0].attributes[1].value
 return month;
};


function thisMonthsScreenings(){
  var month = thisMonth();
  $.ajax({
    method: 'GET',
    url: ("/screenings/" + month)
  })
  .done(function(response){
    addScreeningsToCalendar(response);
    return true;
  })
  .error(function(xhr,error,status){
    alert(error);
  })
};

// ajax request to get json of all screenings for this month
 // have json be organized by day of month
 // '1'=> {showtimes: ['hh:mmam/pm'], film: 'film-name'}

//append the movie name and  showtimes to the corresponding td square
