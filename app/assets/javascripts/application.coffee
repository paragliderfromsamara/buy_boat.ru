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

#для выводит мультилокальную строку в виде записи 'ru {com}'
@MultLocStr = (ru, com)-> "#{ru}#{if com is '' then '' else " {#{com}}"}"

#Обрезает текст t по длине l
@TrimText = (t, l)->
    if t is undefined then console.error "Не задан текст"
    if l is undefined then console.error "Не задана длина"
    if t is null then return ""
    if t.length > l then "#{t[0..l-1]}..." else t
#ищем номер элемента в массиве
@IndexOf = (arr, el)->
    for i in [0..arr.length-1]
        if arr[i] is el then return i
    -1
@IndexOfById = (arr, id)->
    if arr.length is 0 then return -1
    for i in [0..arr.length-1]
        if arr[i].id is id then return i
    -1
#ищем последний номер элемента el в массиве arr    
@LastIndexOf = (arr, el)->
    idx = -1
    for i in [0..arr.length]
        if arr[i] is el then idx = i
    idx
@ConvertArrToStr = (a)-> "#{a.join()}"
#use on boat_filter
@MakeStrArrayFromString = (s)->
    arr = []
    if s.length > 0
        tmp = ''
        idx = 0
        for c in s
            if c is "," or c is ']' or idx is s.length and tmp.length > 0
                arr.push("#{$.trim(tmp)}")
                tmp = ''
            else if c isnt "[" then tmp += c
            idx++ 
    return arr
@ESCQuotes = (txt)->
    s = ""
    idx = 0
    for l in txt
        if l is '"' then s += '\\'
        s+=l
    return s

@SelOptAmount = (n)->
    if n is undefined then return ''
    if n is 0 then '' else "#{AddWhiteSpaceToNumb(n)} ₽"

    
@MakeIntArrayFromString = (s)->
    ConvertArrMembersToInt(MakeStrArrayFromString(s))
@ConvertArrMembersToInt = (a)->
    a.map (v)->
        t = parseInt(v, 10)
        return if t is NaN then 0 else t
#формирует строку для data-interchange из хэша фотографии
@MakeInterchangeData = (ph, isWide)->
    if ph is null or ph is undefined then return ""
    if isWide then "[#{ph.wide_small}, small], [#{ph.wide_medium}, medium], [#{ph.wide_large}, large]" else "[#{ph.small}, small], [#{ph.medium}, medium], [#{ph.large}, large]" 

@AddWhiteSpaceToNumb = (n)->
    n = n.toString()
   #if n / 3 > 0
    v = n.split("").reverse()
    v = v.map (item, idx)-> 
        if (idx+1) % 3 is 0 then " #{item}" else "#{item}"
    $.trim v.reverse().join("")
        
@UpdArrItem = (arr, o, n)->
    idx = IndexOf(arr, o)
    if idx isnt -1 then arr[idx] = n
    return arr

@initTabs = ->
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
    
@NoPhoto = (type)->
    type = if type is undefined then "square" else type
    "/files/nophoto_#{type}.jpg"
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
