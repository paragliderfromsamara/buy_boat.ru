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
#= require ./application
#= require_tree ./realcraft

fResFunction = ->
    f = $('#footer')
    c = f.find '#footer-contacts'
    l = f.find '#footer-logo'
    st = Foundation.MediaQuery.current
    if st isnt 'small'
        f.html(l).append(c)
        l.removeClass 'tb-pad-s'
    else
        f.html(c).append(l)
        l.addClass("tb-pad-s")
    true

wResFunction = ->
    $(".orbit-container").height($(".orbit").height())
    fResFunction()

changeTabsEvent = ->
    tOffset = $("#rc-data-tabs").offset().top - 20
    curScroll = $(window).scrollTop()
    history.pushState('', '', $('[data-tabs]').find(".is-active a").attr("href"))
    if Math.abs(tOffset-curScroll) > 15 then $('html, body').stop(true, true).animate({ scrollTop: tOffset }, 1000)
    return false

r = ->
    FoInit()
    reqHash = GetReqHash()
    wResFunction()
    $("#rc-data-tabs").on 'change.zf.tabs', changeTabsEvent
    if $('[data-tabs]').length > 0 and reqHash.length > 1 then $("#rc-data-tabs").foundation('selectTab', $(reqHash))
    #InitViewer()
    return true
    
document.addEventListener "turbolinks:load", r
$(window).resize(wResFunction)
        