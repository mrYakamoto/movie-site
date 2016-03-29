"use strict";

$('document').ready(function(){

  addAllTooltips();
  addBackgroundToAllEmptyDays();

  theaterTabListener();

  dropDownLinksListener();

})

function theaterTabListener(){
  $('li.theater-tab-box').click(function(){
    $('li.theater-tab-box.active').removeClass('active');
    $( this ).addClass('active');
  })
}

function dropDownLinksListener(){
  $('div#navbar-collapse-1 a').click(function(){
    $('div#navbar-collapse-1').toggleClass('in');
  })
}

function addBackgroundToAllEmptyDays(){
  var $emptyDates = $( 'td.date-box:has( > span.placeholder )');
  $emptyDates.addClass('gradient')
  var $pastEmptyDates = $( 'td.date-box:has( > span.past-placeholder )');
  $pastEmptyDates.addClass('gradient')
}


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
      inactive: 1500
    },
    style: { classes: 'qtip-tipsy' },
    position: {
      my: 'top left',
      at: 'top left'
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
}

function removeWatchlistListings(film_id){
  var $filmListings = $(".user-watchlist div.film-listing-container#film-"+film_id)
  var $dateBoxes = $filmListings.parent();
  $filmListings.remove();
  $dateBoxes.each(function(){
    if ($(this).has('div.film-listing-container').length === 0){
      $(this).append("<br><span class='placeholder hidden-sm hidden-md hidden-lg hidden-xl'></span>");
      $(this).addClass('gradient')
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
