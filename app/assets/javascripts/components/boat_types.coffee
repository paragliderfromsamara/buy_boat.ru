#@BoatParameterType = React.createClass
#    render: ->

#Используется для отображения цены в таблице с выбранными опциями
@SelOptAmount = (n)->
    if n is undefined then return ''
    if n is 0 then '' else "#{n} ₽"
    

@SelectedOptionRow = React.createClass
    render: ->
        cols = 3
        React.DOM.tr null,
            React.DOM.td null, @props.so.name
            React.DOM.td null, SelOptAmount(@props.so.amount)
            

@BoatForSaleGroup = React.createClass  
    toggleGroup: (e)->
        @props.group.isOpen = !@props.group.isOpen
        @props.toggleHandle(@props.group)
    render: ->
        React.DOM.div null,
            React.DOM.hr null, null
            React.DOM.div 
                className: 'row'
                React.DOM.div
                    className: "small-8 columns"
                    React.DOM.h5 
                        key: "#{@props.group.id}-h4" 
                        onClick: @toggleGroup,
                        style: {cursor: 'pointer'}
                        React.DOM.i
                            className: "fi-#{if @props.group.isOpen then "minus" else "plus"}"
                        React.DOM.span null,
                            " #{@props.group.name}"
                React.DOM.div
                    className: "small-4 columns text-right"
                    React.DOM.p null,
                        SelOptAmount(@props.bfsList[@props.group.id].amount)
            if @props.group.isOpen
                React.DOM.div   
                    id: "table-container-#{@props.group.id}"
                    React.DOM.table key: "table-#{@props.group.id}",
                        React.DOM.tbody null,
                            for so in [@props.group.id+1..@props.bfsList.length-1]
                                 if @props.bfsList[so].rec_level is '1' then break
                                 if @props.bfsList[so].rec_type isnt "Группа" then React.createElement SelectedOptionRow, key: "#{so}-ot", so: @props.bfsList[so]

@BoatForSaleShow = React.createClass
    toggleGroup: (g)->
        @props.updBfsListFunc(@props.groups.map (grp)-> if grp.name is g.name then g else grp)
    render: ->
        React.DOM.div
            id: 'bfs-show'
            for g in @props.groups
                if g.isEnable then React.createElement BoatForSaleGroup, key: "group-#{g.id}", group: g, bfsList: @props.bfs.selected_options_for_show, toggleHandle: @toggleGroup 
        

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
        if @state.bfsData.length == 0 then return null
        for bfs in @state.bfsData
            if id is bfs.id then return bfs     
        return null
    
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
    render: ->
        if @state.curBfs is null
            @setBfs(@state.bfsList[0].id)
            React.DOM.div null, ''
        else
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
    
@BoatPhoto = React.createClass
    render: ->
        React.DOM.div
            className: "column tb-pad-xs"
            React.DOM.a null,
                React.DOM.img
                    src: @props.photo.small
                    className: "kra-ph-box"
                    "data-collection": "boat_photo"
                    "data-image-versions": "[#{@props.photo.small}, small], [#{@props.photo.medium}, medium],[#{@props.photo.large}, large]"  
                    #"data-interchange": "[#{@props.photo.small}, small], [#{@props.photo.medium}, medium],[#{@props.photo.large}, large]"

@BoatTypeShow = React.createClass
    getInitialState: ->
       type: @props.data.type
       parameters: @props.data.parameters
       photos: @props.data.photos
       bfsList: @props.data.boat_for_sales
    getDefaultProps: ->
       type: null
       parameters: []
       photos: []
       bfsList: []
    render: ->
        React.DOM.div null,
            React.DOM.div
                className: "row tb-pad-m"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.ul
                        className: "bb-inline-menu"
                        "data-tabs": ""
                        id: "bb-tabs"
                        "data-deep-link": "false"
                        "data-turbolinks":"false"
                        if @state.bfsList.length > 0
                            React.DOM.li
                                className: "tabs-title is-active"
                                React.DOM.a
                                    href: "#boat-for-sales"
                                    "Скомплектованные лодки"
                        React.DOM.li
                            className: "tabs-title#{if @state.bfsList.length > 0 then "" else " is-active"}"
                            React.DOM.a
                                href: "#technical"
                                "Технические характеристики"
                        React.DOM.li
                            className: "tabs-title"
                            React.DOM.a
                                href: "#photos"
                                "Фото"
            React.DOM.div
                className: "tabs-content"
                "data-tabs-content": "bb-tabs"
                React.DOM.div
                    className: "tabs-panel#{if @state.bfsList.length > 0 then "" else " is-active"}"
                    id: "technical"
                    "data-animate":"fade-in fade-out"
                    React.DOM.div
                        className: "row tb-pad-m"
                        React.DOM.div
                            className: "small-12 columns"
                            React.createElement BoatParameterValuesTableShow, key: "BoatParameterValuesTableShow_1", data: @state.parameters
                React.DOM.div
                    className: "tabs-panel"
                    id: "photos"
                    "data-animate":"fade-in fade-out"
                    React.DOM.div
                        className: "row small-up-1 medium-up-3 large-up-4 tb-pad-m"
                        for p in @state.photos
                            React.createElement BoatPhoto, key: p.id, photo: p
                if @state.bfsList.length > 0
                    React.DOM.div
                        className: "tabs-panel is-active"
                        id: "boat-for-sales"
                        "data-animate":"fade-in fade-out"
                        React.createElement BoatForSales, key: "bfs-list", bfsList: @state.bfsList
                        
                        
                                      
