"use strict";

$('document').ready(function(){
  addBuzzBoxPosterListener();
  addToolTips();
  addToWatchlistListener();
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

function addToolTips(){

  $('.hasTooltip').each(function(){
   $(this).qtip({
    content: $(this).next('.tooltipContent:first'),
    show: 'click',
    hide: 'unfocus',
    style: {
      classes: 'qtip-tipsy'
    },
    position: {
      my: 'center',
      at: 'bottom center'
    }
  });
 });
}

function addToWatchlistListener(){
  $('div.tooltipContent a').click(function(e){
    e.preventDefault();
    var data = {film_id: this.id}
    $.ajax({
      method: 'POST',
      url: '/users_films',
      data: data
    })
    .done(function(response){
      console.log(response)
    })
    .error(function(xhr, unknown, error){

      alert(error);
    })
  })
}