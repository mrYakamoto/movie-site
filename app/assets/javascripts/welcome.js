"use strict";

$('document').ready(function(){
  updateAllOnUserLogin();
  theaterTabListener();
  dropDownLinksListener();
})

function fillWatchlistButtons(userFilms){
  $('a.watchlist-button').each(function(){
    var filmId = $( this ).closest('.thumbnail[data-film-id]').attr('data-film-id')
    if (userFilms[filmId]){
      $( this ).text('remove from watchlist')
    } else {
      $( this ).text('add to watchlist')
    }
  })
}

function addAllWatchlistButtonListeners(){
  $('a.watchlist-button').each(function(){
    watchlistButtonListener(this);
  })
}

function watchlistButtonListener(watchlistButton){
  $(watchlistButton).click(function(e){
    e.preventDefault();
    if (userLoggedIn()){
    var data = {};
    data.film_id = $( watchlistButton ).closest('.thumbnail[data-film-id]').attr('data-film-id');
    if ( $( watchlistButton ).text() == "remove from watchlist" ){
      removeFilmFromWatchlist(data);
      $( watchlistButton ).text("add to watchlist");
    } else {
      addFilmToWatchlist(data);
      $( watchlistButton ).text("remove from watchlist");
    }
  } else {
    flashError("log in to save movies to your own watchlist");
  }
  })
}


function updateAllOnUserLogin(){
  $.ajax({
    method: 'GET',
    url: '/current_user_films'
  })
  .done(function(response){
    var userFilms = response;
    fillWatchlistButtons(userFilms);
    addAllWatchlistButtonListeners();

    populateTooltipContent(userFilms);
    addAllTooltips();
    addBackgroundToAllEmptyDays();
    })
  .error(function(xhr, unknown, error){

  })
}

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

function populateTooltipContent(usersFilms){
  $('.tooltipContent').each(function(){
    var filmId = $(this).attr('data-value')
    if ( usersFilms[filmId] ){
      $(this).removeClass('add-film remove-film');
      $(this).addClass('remove-film');
    } else {
      (this).removeClass('add-film remove-film');
      $(this).toggleClass('add-film');
    }
  })
}


// TOOLTIPS
function addAllTooltips(){
  console.log("ADD ALL TOOL TIPS");
  if (userLoggedIn()){
    console.log("USER LOGGED IN");
    $(".qtip").remove();

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
  var isOnWatchlist = toolTipIsOnWatchlist.call(tooltipContent);

  $(tooltipContent).click(function(){
    if (!isOnWatchlist){
      addFilmToWatchlist(data);
    } else if (isOnWatchlist){
      removeFilmFromWatchlist(data);
    }
    $(tooltipContent).off('click');
    switchTooltips.call(tooltipContent);
  })
}


function toolTipIsOnWatchlist(){
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


function userLoggedIn(){
  var $userCal = $('div#user-cal');
  if ( $userCal.attr('data-user') == 'true' ){
    return true;
  } else {
    return false;
  }
}
// END OF USERS