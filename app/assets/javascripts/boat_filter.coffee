# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
fId = "boat-filter"

@initFilter = ()->
    el = document.getElementById(fId)
    if el isnt null then f = new myFilter($(el))      
        
minVal = (vals)->
    min = -1
    (min = if min is -1 then v.value else (if v.value < min then v.value else min)) for v in vals    
    min
maxVal = (vals)->
    max = -1
    (max = if max is -1 then v.value else (if v.value > max then v.value else max)) for v in vals
    max              


class @myFilter
    constructor: (
                    @fEl = null
                    @cntBlock = 'kra-filter-controls' #блок управления фильтром
                    @frBlock = "kra-filter-result"    #блок результата фильтрации
                    @cnt = null
                    @fr = null
                    @data = {}
                    @bTypes = []
                    @filters = new Array()
                  )-> 
                      @procData()   #обрабатываем входящие данные
                      @makeNodes()  #создаем основные контейнеры
                      @makeFilterList() #создаётся список фильтров
                      @makeControls() #добавляются кнопки
    filtering: ->
        tmp = @filters[0].values
        if @filters.length > 0
            for f in [1..@filters.length]
                if !f.isEnable then continue
                if f.values.length is 0 || tmp.length is 0 #если какой-либо из массивов пуст - выводим сообщение что поиск не дал результатов
                    @emptyResultMsg()
                else
                    _tmp = []
                    for v in tmp 
                        if f.values.indexOf(v) > -1 then _tmp.push(v) else continue
                    tmp = _tmp
        @getBoatTypes(tmp)
    getBoatTypes: (bTypesIds)->
        if bTypesIds is undefined then return else (if bTypesIds.length is 0 then return)
        unknownList = []
        for id in bTypesIds
            f = false
            for bt in @bTypes
                if (f = bt.id is id) then break
            if !f then unknownList.push(id)
        if unknownList.length > 0 
            $.ajax(
                    url: "/boat_types"
                    type: "GET"
                    dataType: "json"
                    data: {ids: bTypesIds}
                    success: (data)=>
                        for bt in data 
                            @bTypes[@bTypes.length] = bt 
                        @getBoatTypes(bTypesIds)
                        # console.log data
                  )
        else
            v = ''
            for bt in @bTypes
                if bTypesIds.indexOf(bt.id) > -1 then v += "<p>#{bt.catalog_name}</p>" 
            @fr.html v
        
    reset: ->
        console.log "reset"
    emptyResultMsg: ->
        @fr.html "<div class = \"row\"><div class = \"small-12 columns\"><p>Поиск не дал результатов, попробуйте поменять критерии</p></div></div>"
    makeFilterList: ->
        if @hasItem("min_hp") and @hasItem("max_hp") then @initHpFilter()   #инициализируем фильтр по мощности мотора
        #if @hasItem("min_length") and @hasItem("max_length") then @initLengthFilter()   #инициализируем фильтр длин
    procData: ->
        if @fEl.attr("data-filter") is undefined
            console.error "Отсутствует атрибут \"data-filter\" с данными для инициализации фильтра"
        else
            @data = ($.parseJSON @fEl.attr("data-filter")).data
    hasItem: (n)-> #проверка есть ли в начальных данных элемент фильтра
        if !(f = @data["#{n}"] isnt undefined) then console.error "Отсутствуют данные для фильтра с тэгом: \"#{n}\""
        f
    addFItem: (n)-> @filters.push({name: n, values: [], isEnable: true}) #добавляем в список фильтров и значений объект фильтра при инициализации
    makeNodes: ->
        @fEl.html "
                    <div id = \"#{@cntBlock}\" class = \"row small-up-1 medium-up-3 tb-pad-s\"></div>
                    <div id = \"#{@frBlock}\"></div>
                  "
        @cnt = $("##{@cntBlock}")
        @fr = $("##{@frBlock}")
    initListeners: ->
         @fr.html @data.toString()
    makeControls: ->
        @cnt.append(
                    "<div class = \"column\">
                         <div class = \"button-group tb-pad-s\">
                             <button id = \"filter-search\" class = \"button success\">Показать</button>
                             <button id = \"filter-res\" class = \"button secondary\">Сброс</button>
                         </div>
                     </div>"
                   )  
        @cnt.find("#filter-res").click ()=> @reset() 
        @cnt.find("#filter-search").click ()=> @filtering()
    updFilterData: (fName, arr)-> #обновляем массив висящий на фильтре
        @filters = @filters.map (v)->
            if v.name is fName then v.values = arr
            return v
    initHpFilter: ->
        fName = "hp-filter"
        @addFItem(fName)
        min = minVal(@data.min_hp.values)
        max = maxVal(@data.max_hp.values)
        @cnt.append(
                    "<div class = \"column\">
                         <p>Мощность подвесного мотора, л.с.</p>
                         <div class = \"row\">
                             <div class = \"small-9 columns\">
                                 <div id = \"hp-filter\" class=\"slider\" data-slider data-end = \"#{max}\" data-step=\"5\" data-start = \"#{min}\"  data-initial-start\"#{min}\" data-initial-end=\"#{max}\">
                                   <span class=\"slider-handle\" data-slider-handle role=\"slider\" tabindex=\"1\" aria-controls=\"hp-val\"></span>
                                   <span class=\"slider-fill\" data-slider-fill></span>
                                 </div>
                             </div>
                             <div class = \"small-3 columns\">
                                 <input id = \"hp-val\" type=\"number\">
                             </div>
                         </div>
                         
                     </div>"
                   )
        $("#hp-filter").foundation()
        $("#hp-filter").on(
                            "changed.zf.slider", ()=>
                                                 arr = []
                                                 v = parseInt @cnt.find("#hp-val").val()
                                                 for minV in @data.min_hp.values
                                                     if v >= minV.value
                                                         for maxV in @data.max_hp.values
                                                             if (v <= maxV.value) and (minV.b_id is maxV.b_id) 
                                                                 arr[arr.length] = maxV.b_id
                                                                 break
                                                 @updFilterData(fName, arr)
                                                 #v = 
                           )
    initLengthFilter: ->
        console.log "initLengthFilter"
                