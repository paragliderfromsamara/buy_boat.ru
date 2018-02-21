# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery
#= require jquery_ujs
#= require motion-ui
#= require foundation-sites
#= require turbolinks
#= require react
#= require react_ujs
#= require ./general_components
#= require ./photo_viewer
#= require ./effects


@XHRErrMsg = (jqXHR)-> #Выдаёт сообщение ошибки при отклике error от сервера. Важно чтобы текст сообщения был указан под меткой :message
    if jqXHR is undefined then return
    if jqXHR.responseJSON is undefined then return
    console.log jqXHR
    alert if jqXHR.responseJSON.message is undefined then jqXHR.statusText else jqXHR.responseJSON.message 

@GetReqHash = -> 
    window.location.hash
    
@FoInit = ->
    $(document).foundation()
@AlterText = (text, alter)-> #возвращает альтернативное значение строки 
    alter = if alter is undefined then '' else alter
    if text is null || text is undefined then alter else text
#для выводит мультилокальную строку в виде записи 'ru {en}'
@MultLocStr = (ru, en)-> "#{ru}#{if en is '' then '' else " {#{en}}"}"

@IsEmptyString = (txt)->
    if txt is undefined then return true
    txt = $.trim(txt)
    txt.length is 0
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
@PushIfIsUniq = (arr, val)->
    if IndexOf(arr, val) is -1 then arr.push(val)
    arr
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

@GetEntityById = (entities, id)->
    if entities is undefined
        entities = []
        console.log 'Список для GetEntityById пуст'
    if id is null || id is undefined then return null
    for e in entities
        if e.id.toString() is id.toString() then return e
    return null

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

@IsRuLocale = ->
    window.location.toString().indexOf(".ru") > -1
    

@GetPropertyByTag = (props, tag)->
    if props.length == 0 then return null
    for p in props
        if p.tag is tag then return p
    return null

@GetPropertyValueTag = (props, tag)->
    p = GetPropertyByTag(props, tag)
    if p is null then 'нет' else p.value

@GetErrorsFromResponse = (r, attrsList)->
    errs = []
    for attr in attrsList
        if r["#{attr}"] isnt undefined
            for err in r["#{attr}"]
                errs.push err
    return errs
#AppReadyFunc = ->
    #Тут вносятся общие функции активируемые при загрузке страницы
    #$(document).foundation()
    #InitViewer() #инициализация просмотрщика фотографий, описание функции в photo_viewer.coffee

#document.addEventListener "turbolinks:load", AppReadyFunc