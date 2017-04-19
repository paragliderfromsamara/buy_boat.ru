#@BoatParameterType = React.createClass
#    render: ->

#Используется для отображения цены в таблице с выбранными опциями

getCurBfsById = (bfss, id)->
    if bfss.length is 0 then return null
    if id is undefined or id is null then id = bfss[0].id
    for bfs in bfss
        if id is bfs.id then return bfs     
    return null

@SelOptAmount = (n)->
    if n is undefined then return ''
    if n is 0 then '' else "#{n} ₽"
    

@BFSSelectedOptions = React.createClass
    componentDidMount: ->
        $("[data-so-group-id]").click ()->
            if $(this).find("i").hasClass("fi-plus")
                $(this).find("i").attr("class", "fi-minus")
                $("[data-so-group=#{$(this).attr("data-so-group-id")}]").show()
            else
                
                $("[data-so-group=#{$(this).attr("data-so-group-id")}]").hide()
                $(this).find("i").attr("class", "fi-plus")
    render: -> 
        React.DOM.div
            className: "row",
            React.DOM.div
                className: "small-12 columns"
                for idx in [0..@props.options.length-1]
                    if @props.options[idx].rec_type isnt "Группа" or @props.options[idx].rec_level isnt '1' then continue
                    React.DOM.div
                        key: "option-group-#{idx}",
                        React.DOM.h5 
                            "data-so-group-id": idx
                            style: {cursor: 'pointer'}
                            React.DOM.i
                                className: "fi-minus"
                            React.DOM.span null,
                                " #{@props.options[idx].name}"
                        React.DOM.div
                            "data-so-group": idx
                            React.DOM.table key: "table-#{@props.options[idx].id}",
                                React.DOM.tbody null,
                                    for so in [idx+1..@props.options.length-1]
                                         if @props.options[so].rec_level is '1' 
                                             idx = so
                                             break
                                         if @props.options[so].rec_type isnt "Группа"
                                             React.DOM.tr key: "#{so}-ot",
                                                 React.DOM.td null, @props.options[so].name
                                                 React.DOM.td null, SelOptAmount(@props.options[so].amount) 
                    

@BoatForSaleShow = React.createClass
    render: -> 
        React.DOM.div
            className: "row"
            React.DOM.div
                className: "small-6 columns text-center"
                React.DOM.p null, "Общая стоимость лодки"
            React.DOM.div
                className: "small-6 columns text-center"
                React.DOM.p null, "Стоимость опций" 
    #toggleGroup: (g)->
    #    @props.updBfsListFunc(@props.groups.map (grp)-> if grp.name is g.name then g else grp)
    #render: ->
    #    React.DOM.div
    #        id: 'bfs-show'
    #        for g in @props.groups
    #            if g.isEnable then React.createElement BoatForSaleGroup, key: "group-#{g.id}", group: g, bfsList: @props.bfs.selected_options_for_show, toggleHandle: @toggleGroup 
        

@BoatForSalesItem = React.createClass
    setBfs: ->
        @props.setBfsHandle(@props.item.id)
    render: ->
        React.DOM.li
            className: "#{if @props.curBfsId is @props.item.id then "active" else ''}"
            React.DOM.a 
                onClick: @setBfs,
                "#{@props.item.amount}-#{@props.item.id}"

@BoatForSales = React.createClass
    getInitialState: ->
        curBfs: null
        bfsList: @props.bfsList
        bfsData: @props.bfsData
        groups: @props.groups
    getDefaultProps: ->
        bfsList: [] 
        bfsData: []
        groups: [] 
    calcAmount: (arr)->
        if arr is undefined then return []
        my = []
        return arr.map (e, i)->
            if e.rec_type is "Группа"
                v = 0
                for j in [i+1..arr.length-1]
                    if parseInt(arr[j].rec_level) <= parseInt(e.rec_level) then break
                    v += arr[j].amount
                e.amount = v
            return e
            
    findBfsInData: (id)->
        getCurBfsById(@state.bfsList, id)
    
    getStepIdx: (name)->
        if @state.groups.length is 0 then return -1
        for i in [0..@state.groups.length-1]
            if name is @state.groups[i].name then return i 
        return -1
    findStepsInData: (sOpts)-> #ищем группы в selected_options
        s = []
        for i in [0..sOpts.length-1]
            if sOpts[i].rec_type is "Группа" and sOpts[i].rec_level is '1' then s[s.length] = {name: sOpts[i].name, id: i, isEnable: true, isOpen: false} 
        return s
    updStepsList: (sOpts)->
        if sOpts is undefined then return []
        s = @findStepsInData(sOpts)
        cur = @state.groups
        v = []
        if cur.length is 0 then cur = s
        else
            s = s.map (so)=>
                        idx = @getStepIdx(so.name)
                        if idx isnt -1 
                            so.isOpen = @state.groups[idx].isOpen
                        return so
            for c in cur
                f = false
                for so in s
                    if (f=so.name is c.name) then break
                if !f
                    c.isEnable = false
                    s[s.length] = c
        return s
        
    updBfsList: (arr)->
        @setState groups: arr
    setBfs: (id)->
        bfs = @findBfsInData(id)
        if bfs isnt null
            steps = if bfs.selected_options_for_show.length > 0 then @updStepsList(bfs.selected_options_for_show) else []
            @setState curBfs: bfs, groups: steps
        else
            $.get(
                    "/boat_for_sales/#{id}",
                    {},
                    (data)=>
                        groups = if data.selected_options_for_show.length > 0 then @updStepsList(data.selected_options_for_show) else []
                        data.selected_options_for_show = @calcAmount(data.selected_options_for_show)
                        arr = @state.bfsData
                        arr[arr.length] = data
                        @setState curBfs: data, bfsData: arr, groups: groups
                        return true
                    ,
                    "json"
                 )
    componentDidMount: ->
        if @state.curBfs is null
            @setBfs(@state.bfsList[0].id)
            React.DOM.div null, ''
    render: ->
        React.DOM.div
            className: "row tb-pad-m"
            React.DOM.div
                className: "small-4 columns"
                React.DOM.ul
                    className: "menu vertical"
                    for i in @state.bfsList
                        React.createElement BoatForSalesItem, key: "bfs-item-#{i.id}", item: i, curBfsId: @state.curBfs.id, setBfsHandle: @setBfs 
            React.DOM.div
                className: "small-8 columns"
                React.createElement BoatForSaleShow, key: "bfs-#{@state.curBfs.id}", bfs: @state.curBfs, bfsList: @state.bfsList, updBfsListFunc: @updBfsList, groups: @state.groups

MiniBlockParameterRow = React.createClass
    render: ->
        React.DOM.div
            className: "row parameters"
            React.DOM.div
                className: "small-6 columns"
                React.DOM.p
                    className: "rc-param-name-b text-center"
                    @props.p.name
            React.DOM.div
                className: "small-6 columns"
                React.DOM.div
                    className: "stat text-center rc-param-val-b"
                    React.DOM.span null, @props.p.value
                    
                    
@BFSMiniBlock = React.createClass
    componentDidMount: ->
        $("[data-bfs-id=#{@props.bfs.id}]").fadeIn(500)
    componentWillUnmount: ->
        $("[data-bfs-id=#{@props.bfs.id}]").fadeOut(500)
    render: ->
        i = 0
        React.DOM.div
            className: "column tb-pad-xs"
            React.DOM.div
                className: "bb-mini-block"
                style: {backgroundImage: "url('#{@props.bfs.photo.small}')", display: "none"}
                "data-bfs-id": @props.bfs.id
                React.DOM.div
                    className: "rc-fog hard-fog dark-blue-bg",
                    null
                React.DOM.div
                    className: "bb-mini-control"
                    React.DOM.div
                        className: "row"
                        React.DOM.div
                            className: "small-12 columns button-group expanded"
                            React.DOM.a
                                className: "button small"
                                href: "/boat_for_sales/#{@props.bfs.id}"
                                "ПОДРОБНЕЕ"
                            React.DOM.a
                                className: "button success small"
                                href: "#"
                                "КУПИТЬ"
                React.DOM.div 
                    className: "row"
                    React.DOM.div
                        className: "small-12 columns text-center"
                        React.DOM.h4 null, @props.bfs.name
                for p in @props.bfs.parameters
                    React.createElement MiniBlockParameterRow, key: "parameter-#{i++}", p: p                            
                React.DOM.div 
                    className: "row tb-pad-xs"
                    React.DOM.div
                        className: "small-12 small-centered columns"
                        React.DOM.div
                            className: "stat text-center rc-param-val-b"
                            id: "cost"
                            if @props.bfs.amount isnt undefined
                                React.DOM.span null, if parseInt(@props.bfs.amount) is NaN then @props.bfs.amount else AddWhiteSpaceToNumb(@props.bfs.amount)
                            React.DOM.span
                                className: "rubl"
                                ""

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
                    if bfs.region is @props.location then React.createElement BFSMiniBlock, key: "#{bfs.id}", bfs: bfs
    
@BFSFilteringResult = React.createClass
    render: ->
        colsClass = if @props.colsClass is undefined || @props.colsClass is null then "small-up-1 medium-up-2" else @props.colsClass
        @locations = GroupByLocation(@props.data)
        if @props.data.length is 0
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.p null, "Поиск не дал результатов, попробуйте поменять критерии"
        else
            if @locations.length > 0
                React.DOM.div null,
                    for l in @locations
                        React.createElement LocaleListBlock, key: "#{l}", location: l, bfss: @props.data, colsClass: colsClass
            else
                React.DOM.div
                    className: "row #{colsClass}"
                    for bfs in @props.data
                        React.createElement BFSMiniBlock, key: "#{bfs.id}", bfs: bfs