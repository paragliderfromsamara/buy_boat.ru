# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require turbolinks
#= require jquery
#= require jquery_ujs
#= require motion-ui
#= require foundation-sites
#= require react
#= require react_ujs
#= require ./components
#= require_tree .


bbMiniAutosize = ()->
    w =  $(".bb-mini-block").width()
    h = if w is 400 then 300 else w*3 / 4 
    $(".bb-mini-block").height h



rFunc = ->
    #ReactOnRails.reactOnRailsPageLoaded();
    InitViewer()
    $(document).foundation()
    #bbMiniAutosize()
    initTabs()
    #$(window).resize ()-> bbMiniAutosize()
    #InitViewer() #find in photo_wiewer.coffee

#$(document).ready rFunc
rendFunc = -> 
    #if $("[data-react-class]").length > 0
    #ReactRailsUJS.unmountComponents()
    #else
    #    ReactRailsUJS.unmountComponents()
    
befRendFunc = -> 
    ReactRailsUJS.unmountComponents() 
    
document.addEventListener "turbolinks:load", rFunc
document.addEventListener "Turbolinks.pagesCached", rendFunc    
document.addEventListener "turbolinks:before-visit", befRendFunc 
