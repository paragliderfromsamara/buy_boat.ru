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
    "
    <div class = \"column\"
        <div class=\"row\">
            <div class=\"small-12 columns\">
                    <p>#{bfs.catalog_name}</p>
                    <p>Стоимость #{bfs.amount}</p>
                    <div class = \"expanded button-group\">
                        <a class = \"button\" href = \"#{bfs.url}\">Перейти</a>
                        <a class = \"button success\" href = \"#\">Купить</a>
                    </div>
            </div>
        </div>
    </div>"

class @myFilter
    constructor: (
                    @fEl = null
                    @cntBlock = 'kra-filter-controls' #блок управления фильтром
                    @frBlock = "kra-filter-result"    #блок результата фильтрации
                    @cnt = null
                    @fr = null
                    @data = []
                    @Filters = new Array()   #массив содержащий фильтров
                    @isFilterChanged = true #флаг изменения фильтра
                  )-> 
                      @procData()   #обрабатываем входящие данные
                      @makeNodes()  #создаем основные контейнеры
                      @makeFilterList() #создаётся список фильтров
                      @makeControls() #добавляются кнопки
                      @getDefaultBoats()
    getDefaultBoats: ->
        if @data.length > 0
            @isFilterChanged = true
            @draw(@data)
    filtering: ->
        tmp = null
        if @Filters.length > 0
            for f in @Filters
                if !f.isEnable then continue
                if tmp is null 
                    tmp = f.values
                else
                    if f.values.length isnt 0 and tmp.length isnt 0 #если какой-либо из массивов пуст - выводим сообщение что поиск не дал результатов
                        _tmp = []
                        for v in tmp 
                            if IndexOf(f.values, v) > -1 then _tmp.push(v) else continue
                        tmp = _tmp
        tmp = if tmp is null then [] else tmp
        tmp = @makeScopedIdsList(tmp)
        @draw(tmp)
    #формируем список id        
    makeScopedIdsList: (Ids)->
        if Ids is undefined 
            return []
        else 
            if Ids.length is 0
                return []
        arr = []
        for b in @data
            #str = JSON.stringify(bfs)
            if IndexOf(Ids, b.id) > -1 then arr.push(b)    
        return arr 
    draw: (boats)->
        if not @isFilterChanged then return
        ReactRailsUJS.unmountComponents()   
        data = JSON.stringify({"data": boats})
            #React.createElement(BoatTypeMiniBlock, @fr[0])
        v = "<div data-react-class = \"BFSFilteringResult\" data-react-props ='#{data}'></div>"
        @fr.html v
        ReactRailsUJS.mountComponents()
        @isFilterChanged = false
    makeFilterList: ->
        @initHpFilter() #if @hasItem("min_hp") and @hasItem("max_hp") then @initHpFilter()   #инициализируем фильтр по мощности мотора
        @initTransomFilter() #if @hasItem("transom") then @initTransomFilter()   #инициализируем фильтр размеров транцев
    procData: ->
        if @fEl.attr("data-filter") is undefined
            console.error "Отсутствует атрибут \"data-filter\" с данными для инициализации фильтра"
        else
            p = $.parseJSON @fEl.attr("data-filter")
            @data = p.data
            #@defaultBoats = p.default_boats
            @fEl.removeAttr("data-filter") #удаляем атрибут с данными фильтра после того как их достаем
    addFItem: (n)-> 
        @Filters.push(
                    {
                        name: n
                        values: []
                        isEnable: true #флаг доступности фильтра
                    }
                ) #добавляем в список фильтров и значений объект фильтра при инициализации
    makeNodes: ->
        @fEl.html "
                    <div id = \"#{@cntBlock}\" class = \"row small-up-1 medium-up-2 large-up-3 tb-pad-s\"></div>
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
                             <button id = \"filter-reset\" class = \"button secondary\">Сбросить</button>
                         </div>
                     </div>"
                   )  
        @cnt.find("#filter-reset").click ()=> @getDefaultBoats()#@reset() 
        @cnt.find("#filter-search").click ()=> @filtering()
    updFilterData: (fName, arr)-> #обновляем массив висящий на фильтре
        @Filters = @Filters.map (v)->
            if v.name is fName then v.values = arr
            return v
        @isFilterChanged = true
    initHpFilter: ->
        fName = "hp-filter"
        @addFItem(fName)
        min = max = 0
        for b in @data
            min = if min is 0 then b.min_hp else (if min > b.min_hp then b.min_hp else min)
            max = if max is 0 then b.max_hp else (if max < b.min_hp then b.max_hp else max)
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
                                                 for b in @data
                                                     if v >= b.min_hp && v <= b.max_hp then arr[arr.length] = b.id
                                                 @updFilterData(fName, arr)
                                                 #v = 
                           )
    updFilterValue: (n, el)->
        s = "selected"
        _this = @
        items = "data-filter-item"
        filter = $("[data-filter-name=#{n}]")
        ids = [] #сюда будут записываться ключи типа bt_1 где 1 это boat_type_id
        #при нажатии на item проверяем 
        if el.hasClass(s)
            if filter.find(".#{s}").length is 1 
                alert "Должен быть выбран хотябы один #{filter.find('#filter-title').text()}!"
                return
            else el.removeClass(s) 
        else 
            el.addClass(s)
        selected = []
        filter.find("[#{items}]").each ()->
            e = $(this)
            e.find("i").attr("class", if e.hasClass(s) then "fi-check" else "fi-x")
            if e.hasClass(s) then selected.push(e.find("[filter-item-value]").text())
        for b in @data
            for s in selected 
                if s is b[n] 
                    ids.push(b.id)
                    break
        @updFilterData(n, ids)
    initTransomFilter: ->
        fName = "transom"
        @addFItem(fName)
        nameList = ""
        transomList = []
        for b in @data
            if IndexOf(transomList, b.transom) is -1 
                transomList.push(b.transom)
                nameList += "<li><a data-filter-item><i class = \"fi-x\"></i> <span filter-item-value>#{b.transom}</span></a></li>"
        @cnt.append(
                    "<div data-filter-name = \"#{fName}\" class = \"column string-vals-filter\">
                         <p id = \"filter-title\"><span>Размер транца</span></p>
                         <ul>#{nameList}</ul>
                     </div>"
                   )
        _this = @
        f = $("[data-filter-name = #{fName}]")
        f.find("[data-filter-item]").click ()->
            _this.updFilterValue(fName, $(this))
        f.find("[data-filter-item]").click()
                
                