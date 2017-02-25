# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


bbMiniAutosize = ()->
    w =  $(".bb-mini-block").width()
    h = if w is 400 then 300 else w*3 / 4 
    $(".bb-mini-block").height h

r = ->
    bbMiniAutosize()
    $(window).resize ()-> bbMiniAutosize()
    

document.addEventListener "turbolinks:load", r