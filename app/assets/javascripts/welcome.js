"use strict";

$('document').ready(function(){
  thisMonthsScreenings();
});


function addScreeningsToCalendar(screenings){
  for (var key in screenings){
    console.log(key);
    for(var i = 0; i < screenings[key].length; i++){
      var movie = screenings[key][i].movie;
      var showtime = screenings[key][i].showtime;
      var theater = screenings[key][i].theater;

      console.log(movie);
      console.log(showtime);
      console.log(theater);
      $("td#td"+key).append("<br><span class='film-title'>"+movie+"</span><br><span class='showtime'>"+showtime+"</span><br><span class='theater-name'>"+theater+"</span>");
    }
  }
  addPlaceholderToEmptyDays();
}

function addPlaceholderToEmptyDays(){
  $('td span:only-child').parent().append("<br><span class='placeholder hidden-sm hidden-md hidden-lg hidden-xl'>no screenings</span>")
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
