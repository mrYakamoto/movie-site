"use strict";

$('document').ready(function(){
  addBuzzBoxPosterListener();
  addWelcomeToolTips();
  wecolmeTooltipClickListener();
});

function cookieValue(){
  var cookieValue = document.cookie.replace(/(?:(?:^|.*;\s*)username\s*\=\s*([^;]*).*$)|^.*$/, "$1");
  return cookieValue;
}

function userLoggedIn(){
  if (cookieValue()){
    return true;
  } else {
    return false;
  }
}

function addBuzzBoxPosterListener(){
  $('div.thumbnail').hover(
    function(){
      $( this ).find('.overlay').fadeIn( 500 );
    },
    function(){
      $( this ).find('.overlay').fadeOut( 500 );
    })
}

function addWelcomeToolTips(){
  if (userLoggedIn()){

    $('body.welcome .hasTooltip').each(function(){
      $(this).qtip({
        content: $(this).next('.tooltipContent:first'),
        show: {
          event: 'click',
          effect: function(offset) {
            $( this ).slideDown( 100 )
          }
        },
        hide: {
          event: 'unfocus',
          effect: function(offset) {
            $( this ).slideUp( 100 )
          },
          inactive: 1300
        },
        style: {
          classes: 'qtip-tipsy'
        },
        position: {
          my: 'top center',
          at: 'bottom center'
        }
      });
    });
  }
}

function wecolmeTooltipClickListener(){
  $('body.welcome div.tooltipContent button').click(function(e){
    var data = {film_id: this.id}
    if ( $(this).hasClass('add-film') ){
      addFilmToWatchlist(data)
    }
    else if ( $(this).hasClass('remove-film') ){
      removeFilmFromWatchlist(data)
    }
  })
}

function addFilmToWatchlist(data){
  $.ajax({
    method: 'POST',
    url: '/users_films',
    data: data
  })
  .done(function(response){
    flashAjaxResponse(response);
  })
  .error(function(xhr, unknown, error){
    alert(error);
  })
}

function removeFilmFromWatchlist(data){
  $.ajax({
    method: 'DELETE',
    url: "/users_films/0",
    data: data
  })
  .done(function(response){
    flashAjaxResponse(response);
  })
  .error(function(xhr, unknown, error){
    alert(error);

  })
}

function addWatchlistTooltips(){
  if (userLoggedIn()){

    $('body.users.show .hasTooltip').each(function(){
      $(this).qtip({
        content: $(this).next('.tooltipContent:first'),
        show: {
          event: 'click',
          effect: function(offset) {
            $( this ).slideDown( 100 )
          }
        },
        hide: {
          event: 'unfocus',
          effect: function(offset) {
            $( this ).slideUp( 100 )
          },
          inactive: 1300
        },
        style: {
          classes: 'qtip-tipsy'
        },
        position: {
          my: 'top center',
          at: 'bottom center'
        }
      });
    });
  }
}

function flashAjaxResponse(response){

  if ( response.success ){
    flashSuccess(response.success)
  }
  else if ( response.errors.film_id ){
    flashError(response.errors.film_id[0])
  }
  else
    console.log("ERROR");
}

function flashError(text){
  $("div.alert-danger").prepend(text).slideDown(150);
  setTimeout(function() {
    $("div.alert-danger").empty().slideUp(150);
  }, 2000);
}

function flashSuccess(text){
  $("div.alert-success").prepend(text).slideDown(150);
  setTimeout(function() {
    $("div.alert-success").empty().slideUp(150);
  }, 2000);
}