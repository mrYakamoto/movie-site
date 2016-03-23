"use strict";

$('document').ready(function(){
  addBuzzBoxPosterListener();

  addAllTooltips();
  addBackgroundToAllEmptyDays();
  theaterTabListener();
});


function theaterTabListener(){
  $('a.theater-tab').click(function(e){
    e.preventDefault();

    $('li.theater-tab-box.active').toggleClass('active');
    $(this).closest('li').toggleClass('active');
  })
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

function addBackgroundToAllEmptyDays(){
  var $empty_dates = $( 'td.date-box:has( > span.placeholder )');
  $empty_dates.addClass('gradient')
}

// AJAX

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
    removeWatchlistListings(data["film_id"]);
  })
  .error(function(xhr, unknown, error){
    alert(error);
  })
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
  $("div.alert-danger").empty().prepend(text).slideDown(150);
  setTimeout(function() {
    $("div.alert-danger").slideUp(150);
  }, 2000);
}

function flashSuccess(text){
  $("div.alert-success").empty().prepend(text).slideDown(150);
  setTimeout(function() {
    $("div.alert-success").slideUp(150);
  }, 2000);
}

// END OF AJAX

// TOOLTIPS

function addAllTooltips(){
  console.log("ADD ALL TOOL TIPS");
  if (userLoggedIn()){
    console.log("USER LOGGED IN");

    $('.hasTooltip').each(function(){
      var target = this
      addTooltip.call(target);
    })
    addAllTooltipClickListeners();
  }
}

function addTooltip(){
  console.log("ADD TOOL TIP")
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
    style: { classes: 'qtip-tipsy' },
    position: {
      my: 'top center',
      at: 'bottom center'
    }
  });
}

function addAllTooltipClickListeners(){
  console.log("ADD ALL TOOLTIP CLICK LISTENERS");
  $('div.tooltipContent').each(function(){
    var tooltipContent = this
    addTooltipClickListener.call(tooltipContent);
  })
}

function addTooltipClickListener(){
  console.log("ADD TOOLTIP CLICK LISTENER")
  var tooltipContent = this


  var data = {film_id: tooltipContent.getAttribute('data-value')};

  $(tooltipContent).click(function(){
    console.log('CLICKED');
    if (!isOnWatchlist.call(tooltipContent)){
      addFilmToWatchlist(data);
    } else if (isOnWatchlist.call(tooltipContent)){
      removeFilmFromWatchlist(data);
    }
    $(tooltipContent).off('click');
    switchTooltips.call(tooltipContent);
  })
}

function isOnWatchlist(){
  console.log("IS ON WATCHLIST?");

  var $tooltipContent = $(this)
  if ( $tooltipContent.hasClass('remove-film') ){
    return true;
  }
  else if ( $tooltipContent.hasClass('add-film') ){
    return false;
  }
}

function switchTooltips(){
  console.log("SWITCH TOOLTIPS");
  var $tooltipContent = $(this);
  var filmId = $tooltipContent.attr('data-value');
  var $allFilmsTooltips = $("div.tooltipContent[data-value='"+filmId+"']");

  $allFilmsTooltips.each(function(){
    var tooltipContent = this;
    $(tooltipContent).toggleClass("add-film remove-film");
    $(tooltipContent).off('click');
    addTooltipClickListener.call(tooltipContent);

  })



  // var qtipId = $toolTipContent.closest('div.qtip').attr('data-qtip-id');
  // var target = $('span[data-hasqtip='+qtipId+']');
  // var api = $(target).qtip('api');



  // $allFilmsToolTips.each(function(){
  //   var tooltipContent = this

  //   $(tooltipContent).toggleClass("add-film remove-film");
  //   addTooltipClickListener.call(tooltipContent);
  // })

}

function removeWatchlistListings(film_id){
  var $filmListings = $("body.users.show div.film-listing-container#film-"+film_id)
  var $dateBoxes = $filmListings.parent();
  $filmListings.remove();
  $dateBoxes.each(function(){
    if ($(this).has('div.film-listing-container').length === 0){
      $(this).append("<br><span class='placeholder hidden-sm hidden-md hidden-lg hidden-xl'></span>");
      $(this).addClass('gradient')
    }
  })
}

// END OF TOOLTIPS

// USERS
function cookieUserValue(){
  var cookieUserValue = document.cookie.replace(/(?:(?:^|.*;\s*)username\s*\=\s*([^;]*).*$)|^.*$/, "$1");
  return cookieUserValue;
}

function userLoggedIn(){
  if (cookieUserValue()){
    return true;
  } else {
    return false;
  }
}
// END OF USERS
