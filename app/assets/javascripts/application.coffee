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
#= require components
#= require_tree .

#ищем номер элемента в массиве
@IndexOf = (arr, el)->
    for i in [0..arr.length]
        if arr[i] is el then return i
    -1
#ищем последний номер элемента el в массиве arr    
@LastIndexOf = (arr, el)->
    idx = -1
    for i in [0..arr.length]
        if arr[i] is el then idx = i
    idx
        
initTabs = ->
    requestHash = window.location.hash
    tabEl = document.getElementById "bb-tabs"
    if tabEl isnt null
        tabEl = $(tabEl)
        $("#bb-tabs").before("<div class = \"bb-inline-underline\"></div>")
        line = $(".bb-inline-underline")
        active = $('[data-tabs]').find(".is-active")
        line.parents("div.columns").css "position", "relative"
        line.height(active.height() * 2.3).width(active.width()).offset({top: active.offset().top, left: active.offset().left})
        $("#bb-tabs").on 'change.zf.tabs', ()->
            active = $('[data-tabs]').find(".is-active")
            tOffset = $("#bb-tabs").offset().top - 50
            curScroll = $(window).scrollTop()
            history.pushState('', '', $('[data-tabs]').find(".is-active a").attr("href"))
            line.animate({left: active.find("a").offset().left - tabEl.offset().left + 15, width: active.find("a").width()}, 500)
            #if Math.abs(tOffset-curScroll) > 15 then $('html, body').stop(true, true).animate({ scrollTop: tOffset }, 800)
            return false
        if $('[data-tabs]').length > 0 and requestHash.length>1 
            $('[data-tabs]').foundation('selectTab', $(requestHash))
    

bbMiniAutosize = ()->
    w =  $(".bb-mini-block").width()
    h = if w is 400 then 300 else w*3 / 4 
    $(".bb-mini-block").height h



rFunc = ->
    InitViewer()
    $(document).foundation()
    bbMiniAutosize()
    initTabs()
    initFilter()
    $(window).resize ()-> bbMiniAutosize()
    #InitViewer() #find in photo_wiewer.coffee

rendFunc = -> 
    ReactRailsUJS.mountComponents() 
    
befRendFunc = -> 
    ReactRailsUJS.unmountComponents() 
    
document.addEventListener "turbolinks:load", rFunc
document.addEventListener "turbolinks:request-end", rendFunc    
document.addEventListener "turbolinks:before-visit", befRendFunc 
