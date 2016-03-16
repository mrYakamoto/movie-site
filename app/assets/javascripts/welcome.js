"use strict";

$('document').ready(function(){
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