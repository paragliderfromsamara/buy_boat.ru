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

BoatForSaleCard = (bfs)->
    "<div class=\"column\">
    <div class=\"card\">
        <div class=\"card-section\">
            <p>#{bfs.catalog_name}</p>
            <p>Стоимость #{bfs.amount}</p>
        </div>
    </div></div>"

class @myFilter
    constructor: (
                    @fEl = null
                    @cntBlock = 'kra-filter-controls' #блок управления фильтром
                    @frBlock = "kra-filter-result"    #блок результата фильтрации
                    @cnt = null
                    @fr = null
                    @data = {}
                    @bTypes = []
                    @bForSales = []
                    @BTfilters = new Array()    #массив содержащий фильтры типов лодок
                    @BFSfilters = new Array()   #массив содержащий фильтры лодок на продажу
                  )-> 
                      @procData()   #обрабатываем входящие данные
                      @makeNodes()  #создаем основные контейнеры
                      @makeFilterList() #создаётся список фильтров
                      @makeControls() #добавляются кнопки
    filtering: ->
        tmp = @BTfilters[0].values
        bfs_tmp = null
        if @BTfilters.length > 0
            for f in [1..@BTfilters.length]
                if !f.isEnable then continue
                if f.values.length is 0 || tmp.length is 0 #если какой-либо из массивов пуст - выводим сообщение что поиск не дал результатов
                    @emptyResultMsg()
                else
                    _tmp = []
                    for v in tmp 
                        if IndexOf(f.values, v) > -1 then _tmp.push(v) else continue
                    tmp = _tmp
        if @BFSfilters.length > 0 
            for bfs in @BFSfilters    
                _tmp = []
                for bt in tmp
                    if bfs.values["bt_#{bt}"] is undefined then continue
                    for i in bfs.values["bt_#{bt}"]
                        _tmp[_tmp.length] = i
                if bfs_tmp is null
                    if _tmp.length > 0 then bfs_tmp = _tmp
                else
                    tm = []
                    for v in bfs_tmp 
                        tm.push(v)#if IndexOf(_tmp, v) > -1 then tm.push(v) else continue
                    bfs_tmp = tm
                #if bfs_tmp is null then break
                #if bfs_tmp.length is 0 then break
        bfs_tmp = if bfs_tmp is null then [] else bfs_tmp
        @getBoatForSale(bfs_tmp)
    getBoatForSale: (bfsIds)->
        if bfsIds is undefined 
            return 
        else 
            if bfsIds.length is 0
                @emptyResultMsg()
                return 
        unknownList = []
        for id in bfsIds
            f = false
            for bfs in @bForSales
                if (f = (bfs.id is id)) then break
            if !f then unknownList.push(id)
        if unknownList.length > 0 
            $.ajax(
                    url: "/boat_for_sales"
                    type: "GET"
                    dataType: "json"
                    data: {ids: unknownList}
                    success: (data)=>
                        for bfs in data 
                            if IndexOf(@bForSales, bfs) is -1 then @bForSales.push(bfs) 
                        @getBoatForSale(bfsIds)
                        # console.log data
                  )
        else
            v = ''
            for bfs in @bForSales
                if IndexOf(bfsIds, bfs.id) > -1 then v += BoatForSaleCard(bfs) 
            @fr.html v
            #console.log "draw"
    getBoatTypes: (bTypesIds)->
        if bTypesIds is undefined 
            return 
        else 
            if bTypesIds.length is 0
                @emptyResultMsg()
                return 
        unknownList = []
        for id in bTypesIds
            f = false
            for bt in @bTypes
                if (f = (bt.id is id)) then break
            if !f then unknownList.push(id)
        if unknownList.length > 0 
            $.ajax(
                    url: "/boat_types"
                    type: "GET"
                    dataType: "json"
                    data: {ids: bTypesIds}
                    success: (data)=>
                        for bt in data 
                            if IndexOf(@bTypes, bt) is -1 then @bTypes.push(bt) 
                        @getBoatTypes(bTypesIds)
                        # console.log data
                  )
        else
            v = ''
            for bt in @bTypes
                if IndexOf(bTypesIds, bt.id) > -1 and bt.boat_for_sales.length > 0 then v += "<p>#{bt.catalog_name}</p>" 
            @fr.html v
            console.log "draw"
    emptyResultMsg: ->
        @fr.html "<div class = \"row\"><div class = \"small-12 columns\"><p>Поиск не дал результатов, попробуйте поменять критерии</p></div></div>"
    makeFilterList: ->
        if @hasItem("min_hp") and @hasItem("max_hp") then @initHpFilter()   #инициализируем фильтр по мощности мотора
        if @hasItem("transom") then @initTransomFilter()   #инициализируем фильтр размеров транцев
    procData: ->
        if @fEl.attr("data-filter") is undefined
            console.error "Отсутствует атрибут \"data-filter\" с данными для инициализации фильтра"
        else
            @data = ($.parseJSON @fEl.attr("data-filter")).data
    hasItem: (n)-> #проверка есть ли в начальных данных элемент фильтра
        if !(f = @data["#{n}"] isnt undefined) then console.error "Отсутствуют данные для фильтра с тэгом: \"#{n}\""
        f
    addFItem: (n, type)-> 
        if type is "bfs"
            @BFSfilters.push(
                        {
                            name: n
                            values: {}
                            isEnable: true #флаг доступности фильтра
                        }
                    ) #добавляем в список фильтров и значений объект фильтра при инициализации
        else
            @BTfilters.push(
                        {
                            name: n
                            values: []
                            isEnable: true #флаг доступности фильтра
                        }
                    ) #добавляем в список фильтров и значений объект фильтра при инициализации
    makeNodes: ->
        @fEl.html "
                    <div id = \"#{@cntBlock}\" class = \"row small-up-1 medium-up-3 tb-pad-s\"></div>
                    <div id = \"#{@frBlock}\" class = \"row small-up-1 medium-up-3 tb-pad-s\"></div>
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
                         </div>
                     </div>"
                   )  
        @cnt.find("#filter-res").click ()=> @reset() 
        @cnt.find("#filter-search").click ()=> @filtering()
    updFilterData: (fName, arr)-> #обновляем массив висящий на фильтре
        @BTfilters = @BTfilters.map (v)->
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
    updBFSFilterValue: (n, el)->
        idxAttr = "data-#{n}-idx"
        s = "selected"
        _this = @
        filter = $("[data-filter-name=#{n}]")
        vals = {} #сюда будут записываться ключи типа bt_1 где 1 это boat_type_id
        #при нажатии на item проверяем 
        if el.hasClass(s)
            if filter.find(".#{s}").length is 1 
                alert "Должен быть выбран хотябы один #{filter.find('#filter-title').text()}!"
                return
            else el.removeClass(s) 
        else 
            el.addClass(s)
        $("[#{idxAttr}]").each ()->
            e = $(this)
            e.find("i").attr("class", if e.hasClass(s) then "fi-check" else "fi-x")
            if e.hasClass(s)
                idx = parseFloat(e.attr(idxAttr))
                if _this.data[n][idx].values.length > 0
                    for v in _this.data[n][idx].values
                        vn = "bt_#{v.b_id}"
                        if vals[vn] is undefined || vals[vn] is null
                            vals[vn] = [v.bfs_id]
                        else
                            vals[vn].push(v.bfs_id)
        
        @BFSfilters = @BFSfilters.map (v)->
            if v.name is n then v.values = vals
            return v
    initTransomFilter: ->
        fName = "transom"
        @addFItem(fName, "bfs")
        nameList = ""
        for i in [0..@data.transom.length-1]
            nameList += "<p><a data-#{fName}-idx = \"#{i}\"><i class = \"fi-x\"></i> #{@data.transom[i].name}</a></p>"
        @cnt.append(
                    "<div data-filter-name = \"#{fName}\" class = \"column\">
                         <p id = \"filter-title\"><span>Размер транца</span></p>
                         #{nameList}
                     </div>"
                   )
        _this = @
        $("[data-#{fName}-idx]").click ()->
            _this.updBFSFilterValue(fName, $(this))
        $("[data-#{fName}-idx]").click()
                
                