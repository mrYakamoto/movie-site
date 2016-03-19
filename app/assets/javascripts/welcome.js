"use strict";

$('document').ready(function(){
  addBuzzBoxPosterListener();

  addAllToolTips();
  addBackgroundToEmptyDays();
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

function addAllToolTips(){

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
    style: {
      classes: 'qtip-tipsy'
    },
    position: {
      my: 'top center',
      at: 'bottom center'
    }
  });
}


function addAllTooltipClickListeners(){
  console.log("ADD ALL TOOLTIP CLICK LISTENERS");
  $('div.tooltipContent').each(function(){
    var toolTipContent = this
    addTooltipClickListener.call(toolTipContent);
  })
}

function addTooltipClickListener(){
  console.log("ADD TOOLTIP CLICK LISTENER")
  var toolTipContent = this
  var data = {film_id: toolTipContent.id};

  $(toolTipContent).click(function(){
    console.log('CLICKED');
    if (!isOnWatchlist.call(toolTipContent)){
      addFilmToWatchlist(data);
    } else if (isOnWatchlist.call(toolTipContent)){
      removeFilmFromWatchlist(data);
    }
    switchTooltips.call(toolTipContent);
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
  var toolTipContent = this;
  var $toolTipContent = $(toolTipContent);

  debugger

  var qtipId = $toolTipContent.closest('div.qtip').attr('data-qtip-id');
  var target = $('span[data-hasqtip='+qtipId+']');
  var api = $(target).qtip('api');

  $toolTipContent.toggleClass("add-film remove-film");
  addTooltipClickListener.call(toolTipContent);
// replace content of qtip
// target.qtip('option', 'content.text', "add to favorites");
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


function addBackgroundToEmptyDays(){
  var $empty_dates = $( 'td.date-box:has( > span.placeholder )');
  $empty_dates.addClass('gradient')
}


