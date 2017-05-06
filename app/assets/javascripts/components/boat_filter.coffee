#@BoatParameterType = React.createClass
#    render: ->

#Используется для отображения цены в таблице с выбранными опциями

#проверяет удовлетворяет ли условию данный элемент

hpFilterData = (d)->
    min = max = -1
    for b in d
        min = if min is -1 then b.min_hp else (if min > b.min_hp then b.min_hp else min)
        max = if max is -1 then b.max_hp else (if max < b.min_hp then b.max_hp else max)
    {name: "hp", min: min, max: max, title: "Мощность П.М., л.с."}

transomFilterData = (d)->
    l = []
    for b in d
        if IndexOf(l, b.transom) is -1 then l.push(b.transom)
    {name: "transom", values: l.sort(), title: "Высота транца"}

regionFilterData = (d)->
    l = []
    for b in d
        if IndexOf(l, b.region) is -1 then l.push(b.region)
    {name: "region", values: l.sort(), title: "Регион"}

checkCondition = (filter, value, item)->
    item["min_#{filter.name}"] <= value && item["max_#{filter.name}"] >= value

checkHasInList = (filter, values, item)->  
    IndexOf(values, item["#{filter.name}"]) > -1

filterValue = (f)->
    v = $("[data-filter-name=#{f.name}]").find("input").val()
    if f.min isnt undefined and f.max isnt undefined 
        v = parseFloat(v, 10)
        return if v is NaN then 0 else v
    else if f.values isnt undefined then return MakeStrArrayFromString(v)
         

filteredIds = (filters, data)->
    idxs = []
    data.forEach (d, idx)-> idxs.push(idx)
    for f in filters
        v = filterValue(f)
        func = if $.type(v) is "number" then checkCondition else checkHasInList
        tmpIdx = []
        for idx in idxs
            if func(f, v, data[idx]) then tmpIdx.push(idx)
        idxs = tmpIdx
        if idxs.length is 0 then break
    ids = []
    for i in idxs
        ids.push(data[i].id)
    return ids   
    
getFilters = (d)->
    if d.length is 0 then return [] 
    filters = []
    if d[0].min_hp isnt undefined and d[0].max_hp isnt undefined then filters.push hpFilterData(d) else console.error "Указаны не все атрибуты hp"
    if d[0].transom isnt undefined then filters.push transomFilterData(d) else console.error "Отсутствует атрибут Transom"
    if d[0].region isnt undefined then filters.push regionFilterData(d) else console.error "Отсутствует атрибут Region"
    filters    

@ListFilter = React.createClass
    vals: ->
        f = $("[data-filter-name=#{@props.f.name}]")
        arr = []
        f.find("a[data-filter-item]").each ()->
            if $(this).hasClass("selected") then arr.push($(this).find("span").text())
        return arr
    updVals: ->
        $("[data-filter-name=#{@props.f.name}]").find("input").val(ConvertArrToStr(@vals()))
        
    componentDidMount: ->
        f = $("[data-filter-name=#{@props.f.name}]")
        itms = f.find("a[data-filter-item]")
        _this = @
        itms.click ()->
            vals = MakeIntArrayFromString(f.find("input").val())
            if $(this).hasClass('selected')
                if vals.length is 1 then alert("Должен быть выбран хотя бы один #{f.find("#filter-title").text()}")
                else
                    $(this).removeClass('selected')
                    $(this).parents("li").find('i').attr("class", "fi-x")
            else
                $(this).addClass('selected')
                $(this).parents("li").find('i').attr("class", "fi-check")
            _this.updVals()  
        itms.click()
        #sel = f.find()
    render: ->
        React.DOM.div
            className: "string-vals-filter"
            "data-filter-name": @props.f.name
            React.DOM.h6 
                id: 'filter-title',
                @props.f.title
            React.DOM.ul null, 
                for v in @props.f.values
                    React.DOM.li
                        key: "#{@props.f.name}-#{v}"
                        React.DOM.a
                            "data-filter-item": ""
                            React.DOM.i
                                className: "fi-x" 
                                " "
                            React.DOM.span null, v
            React.DOM.input
                type: "hidden"
                value: if @props.f.default isnt undefined then @props.f.default else ConvertArrToStr(@vals())
                
            
@SliderFilter = React.createClass
    render: ->
        React.DOM.div
            "data-filter-name": @props.f.name
            React.DOM.h6 null, @props.f.title
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-8 columns"
                    React.DOM.div
                        id: "#{@props.f.name}-filter"
                        className: "slider"
                        "data-slider": ""
                        "data-end": @props.f.max
                        "data-start": @props.f.min
                        "data-step": if @props.f.step is undefined then 5 else @props.f.step
                        "data-initial-start": if @props.f.default is undefined then @props.f.min else @props.f.default
                        React.DOM.span
                            className: "slider-handle"
                            "data-slider-handle": ""
                            role: "slider"
                            tabIndex: 1
                            "aria-controls": "hp-val"
                            null
                        React.DOM.span
                            className: "slider-fill"
                            "data-slider-fill": ""
                React.DOM.div
                    className: "small-4 columns"
                    React.DOM.input
                        type: "number"
                        id: "hp-val"

@BFSFilterBoatsListMenu = React.createClass
    setActionHandle: (e)->
        e.preventDefault()
        @props.goToFunc()
    changeListHandle: (e)->
        e.preventDefault()
        @props.changeList()
    render: ->
        React.DOM.div
            className: "row"
            React.DOM.div
                id: "filter-result-control"
                className: "small-12 columns"
                React.DOM.div
                    className: "button-group"
                    React.DOM.a
                        onClick: @setActionHandle
                        className: "button secondary"
                        React.createElement IconWithText, txt: (if @props.action is "favorites" then "к списку лодок" else "избранное"), fig: (if @props.action is "favorites" then "arrow-left" else "star")
                    React.DOM.a
                        onClick: @changeListHandle
                        className: "button secondary"
                        React.createElement IconWithText, txt: (if @props.is_list then "миниатюры" else "список"), fig: (if @props.is_list then "thumbnails" else "list")
                    
        
@BFSFilter = React.createClass
    getInitialState: ->
        data: @props.data
        curBfs: if @props.curBfs is undefined then null else @props.curBfs
        filters: getFilters(@props.data)
        boatForSales: if @props.boatForSales is undefined then [] else @props.boatForSales
        favorites: if @props.favorites is undefined then [] else @props.favorites
        action: @props.action
        showAsList: true 
    setDefaultState: ->
        data: []
        curBfs: null
        filters: []
        action: "index"
        boatForSales: []
        favorites: []
    setBfss: (bfss)->
        @setState boatForSales: bfss
    SetAction: (name, bfs)->
        @setState action: name, curBfs: (if bfs is undefined then null else bfs)
    GoToIndex: -> 
        @SetAction("index")
        window.history.pushState(null, null, "/boat_for_sales")
    GoToFavorites: -> 
        @SetAction("favorites")
        window.history.pushState(null, null, "/favorites")
    goToBfsClickHandle: (bfs_id)->
        loc =  "/boat_for_sales/#{bfs_id}"
        $.ajax(
                url: loc
                dataType: "json"
                success: (d)=>
                    @SetAction("show", d)
                    window.history.pushState(null, null, loc)
              )
    SwitchListToThumbnail: ->
        @setState showAsList: !@state.showAsList
    filteringHandle: (e)->
        e.preventDefault()
        @GoToIndex() 
        vals = filteredIds(@state.filters, @state.data)
        str_loc = "#{window.location.pathname}?#{$.param([{name: "ids", value: vals}])}"
        if vals.length > 0
            $.getJSON(
                window.location.pathname, 
                {ids: vals}, 
                (data)=>
                    @setBfss(data)
                    window.history.replaceState(null, null, str_loc)
            )
        else @setBfss([])
    IsOnFavorites: (id)->
        if @state.favorites.length is 0 then return false
        for f in @state.favorites
            if f.id is id then return true
        return false
    switchFavoriteHandle: (e)->
        e.preventDefault()
        $.getJSON( 
                "/boat_for_sales/#{@state.curBfs.bfs.id}/switch_favorites",
                {},
                (d)=>
                    if d.favorites isnt undefined then @setState favorites: d.favorites
             )
    componentDidMount: ->
        $("#filters").foundation()
    #    console.log "BFSFilter DidMount"
    #    console.log @state.filters
    #componentWillUnmount: ->
    #    console.log "BFSFilter WillUnmount"
    render: ->
        if @state.filters.length is 0 
            React.DOM.div
                className: "row tb-pad-s",
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.p null, "Лодки в наличии отсутствуют."
        else
            React.DOM.div
                id: "BaseFilterRow"
                className: "row tb-pad-m",          
                React.DOM.div
                    className: "small-12 medium-4 large-3 columns show-for-medium"
                    "data-sticky-container":""
                    React.DOM.div
                        className: "sticky"
                        "data-sticky":""
                        id: "filters"
                        "data-top-anchor": "BaseFilterRow:top" #начинает отрываться когда скролл проходит данный элемент
                        React.DOM.h5 null,
                            React.DOM.i
                                className: "fi-filter"
                                " "
                            React.DOM.span null, "Фильтр"
                        for f in @state.filters
                            if f.min isnt undefined and f.max isnt undefined
                                React.createElement SliderFilter, key: f.name, f: f
                            else if f.values isnt undefined
                                if f.values.length > 0 then React.createElement ListFilter, key: f.name, f: f
                        React.DOM.div null, 
                            React.DOM.div
                                className: "button-group"
                                React.DOM.a
                                    className: "button success expanded"
                                    onClick: @filteringHandle
                                    "ПРИМЕНИТЬ"
                React.DOM.div 
                    className: "small-12 medium-8 large-9 columns"
                    if @state.action is "show"
                        React.DOM.div null,
                            React.DOM.div
                                className: "row"
                                React.DOM.div
                                    id: "filter-result-control"
                                    className: "small-12 columns"
                                    React.DOM.div
                                        className: "button-group"
                                        React.DOM.a
                                            onClick: @GoToIndex
                                            className: "button secondary"
                                            React.createElement IconWithText, txt: "к списку лодок", fig: "arrow-left"
                                        React.DOM.a
                                            onClick: @GoToFavorites
                                            className: "button secondary"
                                            React.createElement IconWithText, txt: "избранное", fig: "star"
                                        React.DOM.a
                                            onClick: @switchFavoriteHandle
                                            className: "button rc-blue"
                                            React.createElement IconWithText, txt: (if @IsOnFavorites(@state.curBfs.bfs.id) then "убрать из избранного" else "добавить в избранное"), fig: "star"
                                        React.DOM.a
                                            onClick: @createRequest
                                            className: "button rc-blue"
                                            React.createElement IconWithText, txt: "купить", fig: "shopping-cart"
                            React.createElement BoatForSaleInFilter, key: "bfs-show", data: @state.curBfs 
                    else if @state.action is "favorites"
                        React.DOM.div null,
                            React.createElement BFSFilterBoatsListMenu, action: @state.action, goToFunc: @GoToIndex, is_list: @state.showAsList, changeList: @SwitchListToThumbnail
                            React.createElement BFSFilteringResult, key: "f-favorites", data: @state.favorites, goToBfsClickHandle: @goToBfsClickHandle, showAsList: @state.showAsList, action: @state.action
                    else
                        React.DOM.div null,
                            React.createElement BFSFilterBoatsListMenu, action: @state.action, goToFunc: @GoToFavorites, is_list: @state.showAsList, changeList: @SwitchListToThumbnail
                            React.createElement BFSFilteringResult, key: "f-result", data: @state.boatForSales, goToBfsClickHandle: @goToBfsClickHandle, showAsList: @state.showAsList, action: @state.action
GroupByLocation = (bfss)->
    locations = []
    for bfs in bfss
        if IndexOf(locations, bfs.region) is -1 then locations.push(bfs.region)
    locations.sort()



@LocaleListBlock = React.createClass
    render: ->
        React.DOM.div 
            className: "tb-pad-s",
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.h4 null, @props.location
            React.DOM.div
                className: "row #{@props.colsClass}"
                for bfs in @props.bfss
                    if bfs.region is @props.location then React.createElement BFSMiniBlock, key: "#{bfs.id}", bfs: bfs, goToBfsClickHandle: @props.goToBfsClickHandle 

@BFSFilteringResult = React.createClass
    render: ->
        colsClass = if @props.colsClass is undefined || @props.colsClass is null then "small-up-2 large-up-4" else @props.colsClass
        @locations = GroupByLocation(@props.data)
        if @props.data.length is 0
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.p null, if @props.action is "favorites" then "В избранном ничего нет" else "Поиск не дал результатов, попробуйте поменять критерии"
        else
            #if @locations.length > 0
            #    React.DOM.div null,
            #        for l in @locations
            #            React.createElement LocaleListBlock, key: "#{l}", location: l, bfss: @props.data, colsClass: colsClass, goToBfsClickHandle: @props.goToBfsClickHandle
            #else
            if @props.showAsList
                React.DOM.div null,
                    for bfs in @props.data
                        React.createElement BFSWideBlock, key: "#{bfs.id}", bfs: bfs, goToBfsClickHandle: @props.goToBfsClickHandle  
            else
                React.DOM.div
                    className: "row #{colsClass}"
                    for bfs in @props.data
                        React.createElement BFSMiniBlock, key: "#{bfs.id}", bfs: bfs, goToBfsClickHandle: @props.goToBfsClickHandle          