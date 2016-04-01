"use strict";

$('document').ready(function(){
  initWatchlistTriggers();

  addBackgroundToAllEmptyDays();
  theaterTabListener();
  dropDownLinksListener();
})


function theaterTabListener(){
  $('li.theater-tab-box').click(function(){
    $('li.theater-tab-box.active').removeClass('active');
    $( this ).addClass('active');
    $('div#theater-nav').removeClass('in')
    $('button#theaters-dropdown-button span.theater-tab').html($(this).text())
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

// WATCHLIST
function initWatchlistTriggers(){
  $.ajax({
    method: 'GET',
    url: '/current_user_films'
  })
  .done(function(response){
    var userLoggedIn = response["user"];
    var userFilms = response["user_films"];

    if ( userLoggedIn ){
      fillWatchlistButtonsUserLoggedIn(userFilms);

      populateTooltipContent(userFilms);
      addAllTooltips();

    } else {
      fillWatchlistButtonsNoUser();
    }

  })
  .error(function(xhr, unknown, error){
    alert(error);
  })
}

function fillWatchlistButtonsNoUser(){
  $('a.watchlist-button').each(function(){
    var watchlistButton = this;
    var filmId = $( this ).closest('.thumbnail[data-film-id]').attr('data-film-id');
    $( this ).text('add to watchlist');
    addWatchlistButtonListenerNoUser(watchlistButton, filmId);
  })
}

function addWatchlistButtonListenerNoUser(watchlistButton, filmId){
  $(watchlistButton).off('click');
  $(watchlistButton).click(function(e){
    e.preventDefault();
    flashError("Log-in to create your own calendar");
  })
}

function fillWatchlistButtonsUserLoggedIn(userFilms){
  $('a.watchlist-button').each(function(){
    var watchlistButton = this;
    var filmId = $( this ).closest('.thumbnail[data-film-id]').attr('data-film-id');
    if ( userFilms[filmId] ){
      $( this ).text('remove from watchlist');
    } else {
      $( this ).text('add to watchlist');
    }
    addWatchlistButtonListenerUserLoggedIn(watchlistButton, filmId);
  })
}

function addWatchlistButtonListenerUserLoggedIn(watchlistButton, filmId){
  $(watchlistButton).off('click');
  $(watchlistButton).click(function(e){
    e.preventDefault();
    var data = {};
    data.film_id = filmId;
    if ( $( this ).text() == "remove from watchlist" ){
      removeFilmFromWatchlist(data);
      $( this ).text("add to watchlist");
    } else {
      addFilmToWatchlist(data);
      $( this ).text("remove from watchlist");
    }
  })
}

// TOOLTIPS
function populateTooltipContent(usersFilms){
  $('.tooltipContent').each(function(){
    var filmId = $(this).attr('data-value')
    if ( usersFilms[filmId] ){
      $(this).removeClass('add-film remove-film');
      $(this).addClass('remove-film');
    } else {
      $(this).removeClass('add-film remove-film');
      $(this).toggleClass('add-film');
    }
  })
}

function addAllTooltips(){
  console.log("ADD ALL TOOL TIPS");
  console.log("USER LOGGED IN");
    $( ".qtip" ).remove();
    $( '.hasTooltip' ).each(function(){
      var target = this
      addTooltip.call(target);
    })
    addAllTooltipClickListeners();
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
    if ( $(tooltipContent).hasClass('add-film') ){
      addFilmToWatchlist(data);
    }
    else if ( $(tooltipContent).hasClass('remove-film') ){
      removeFilmFromWatchlist(data);
    }
    switchTooltips.call(tooltipContent);
  })
}

function switchTooltips(){
  console.log("SWITCH TOOLTIPS");
  var $tooltipContent = $(this);
  var filmId = $tooltipContent.attr('data-value');
  var $allFilmsTooltips = $("div.tooltipContent[data-value='"+filmId+"']");

  $allFilmsTooltips.each(function(){
    var tooltipContent = this;
    $(tooltipContent).toggleClass("add-film remove-film");
  })
}

// CALENDAR
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

// DB CALL AND RESPONSE

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