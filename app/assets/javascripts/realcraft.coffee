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



enDict = {
            modifications: "Modifications"
            design_category: "Design category"
            technical_information: "Technical Information"
            photos: "Photos"
            videos: "Videos"
            engeneering: "Engeneering"
            buy: 'Send request'
            top_view: 'Top view'
            aft_view: 'Aft view'
            bow_view: 'Bow view'
            scheme: 'Scheme'
            crew_accomodation: 'Crew accomodation'
            model: 'Model'
            no_videos_msg: "No videos were added."
            no_photos_msg: "No photos were added."
         }
         
ruDict = {
            modifications: "Модификации"
            design_category: "Класс"
            technical_information: "Характеристики"
            photos: "Фото"
            videos: "Видео"
            engeneering: "Инженерия"
            buy: "Отправить запрос"
            top_view: 'Вид сверху'
            aft_view: 'Вид с кормы'
            bow_view: 'Вид с носа'
            scheme: 'Схема'
            crew_accomodation: "Размещение пассажиров"
            model: 'Модель'
            no_videos_msg: "Не было добавлено ни одного видео."
            no_photos_msg: "Не было добавлено ни одной фотографии."
         }
@Dict = if IsRuLocale() then ruDict else enDict

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

#удалить так как реализовано в components/boat_type.coffee
changeTabsEvent = ->
    tOffset = $("#rc-data-tabs").offset().top - 20
    curScroll = $(window).scrollTop()
    history.pushState('', '', $('[data-tabs]').find(".is-active a").attr("href"))
    if Math.abs(tOffset-curScroll) > 15 then $('html, body').stop(true, true).animate({ scrollTop: tOffset }, 1000)
    return false

r = ->
    FoInit()
    #reqHash = GetReqHash()
    wResFunction()
    #$("#rc-data-tabs").on 'change.zf.tabs', changeTabsEvent
    #if $('[data-tabs]').length > 0 and reqHash.length > 1 then $("#rc-data-tabs").foundation('selectTab', $(reqHash))
    #InitViewer()
    return true

befRendFunc = -> 
    ReactRailsUJS.unmountComponents() 
    
   
document.addEventListener "turbolinks:before-visit", befRendFunc 

document.addEventListener "turbolinks:load", r
$(window).resize(wResFunction)
        