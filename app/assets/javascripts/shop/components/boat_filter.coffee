#@BoatParameterType = React.createClass
#    render: ->

#Используется для отображения цены в таблице с выбранными опциями

@ListFilterItem = React.createClass
    toggleItem: (e)->
        e.preventDefault()
        @props.toggleHandle(@props.item[0], @props.isSelected)
    render: ->
        React.DOM.li
            key: "#{@props.f.name}-#{@props.item[0]}"
            React.DOM.a
                onClick: @toggleItem
                React.createElement IconWithText, fig: (if @props.isSelected then "check" else "x"), txt: @props.item[1]
                
@ListFilter = React.createClass   
    toggleItem: (itemIdx, isSelected)->
        if not isSelected
            defVals = @props.f.default.slice()
            defVals.push(itemIdx)
            @props.changeValueHandle(@props.f.name, defVals)
        else
            if @props.f.default.length is 1 
                alert("Должен быть выбран хотя бы один #{$("[data-filter-name=#{@props.f.name}]").find("#filter-title").text()}")
            else
                defVals = []
                for d in @props.f.default
                    if d isnt itemIdx then defVals.push(d)
                @props.changeValueHandle(@props.f.name, defVals)
            #if vals.length is 1 then alert("Должен быть выбран хотя бы один #{f.find("#filter-title").text()}")
    isSelectedItem: (itemIdx)->
        isSel = false
        for defVal in @props.f.default
            if (isSel = defVal is itemIdx) then break
        isSel
    render: ->
        React.DOM.div
            className: "string-vals-filter"
            "data-filter-name": @props.f.name
            React.DOM.h6 
                id: 'filter-title',
                @props.f.title
            React.DOM.ul null, 
                for v in @props.f.values
                    React.createElement ListFilterItem, key: "#{@props.f.name}-#{v[0]}", item: v, f: @props.f, toggleHandle: @toggleItem, isSelected: @isSelectedItem(v[0]) 
                
            
@SliderFilter = React.createClass
    componentDidMount: ->
        $("##{@props.f.name}-filter").on "changed.zf.slider", ()=> @props.changeValueHandle(@props.f.name, $("##{@props.f.name}-filter-val").val())
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
                        "data-end": @props.f.values[1]
                        "data-start": @props.f.values[0]
                        "data-step": if @props.f.step is undefined then 5 else @props.f.step
                        "data-initial-start": if @props.f.default is undefined then @props.f.values[0] else @props.f.default
                        React.DOM.span
                            className: "slider-handle"
                            "data-slider-handle": ""
                            role: "slider"
                            tabIndex: 1
                            "aria-controls": "#{@props.f.name}-filter-val"
                            null
                        React.DOM.span
                            className: "slider-fill"
                            "data-slider-fill": ""
                React.DOM.div
                    className: "small-4 columns"
                    React.DOM.input
                        type: "number"
                        id: "#{@props.f.name}-filter-val"

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
        curBfs: if @props.curBfs is undefined then null else @props.curBfs
        filters: @props.data
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
    updFilterValue: (fName, fValue)->
        filters = @state.filters.slice()
        filters.map (f)->
            if f.name is fName then f.default = fValue
            return f
        @setState filters: filters
    filteringHandle: (e)->
        e.preventDefault()
        @GoToIndex() 
        prms = []
        prmsObj = {}
        for f in @state.filters
            v = if f.type is "collection" then ConvertArrToStr(f.default) else f.default #$("##{f.name}-filter-val").val()
            prms.push {name: f.name, value: v}
            prmsObj[f.name] = v
        #vals = [] #filteredIds(@state.filters, @state.data)
        str_loc = "#{window.location.pathname}?#{$.param(prms)}"
        if prms.length > 0
            $.getJSON(
                window.location.pathname, 
                prmsObj, 
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
                            if f.type is "range"
                                React.createElement SliderFilter, key: f.name, f: f, changeValueHandle: @updFilterValue
                            else
                                if f.values.length > 0 then React.createElement ListFilter, key: f.name, f: f, changeValueHandle: @updFilterValue
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
                                            className: "button rc-blue"
                                            href: "/boat_for_sales/#{@state.curBfs.bfs.id}/buy"
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