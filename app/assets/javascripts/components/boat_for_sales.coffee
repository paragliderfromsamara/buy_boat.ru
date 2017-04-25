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
    if n is 0 then '' else "#{AddWhiteSpaceToNumb(n)} ₽"
    

GroupSelectedOptions = (sOpts)->
    groups = []
    for idx in [0..sOpts.length-1]
        if sOpts[idx].rec_type isnt "Группа" or sOpts[idx].rec_level isnt '1' then continue
        name = sOpts[idx].name 
        groupAmount = sOpts[idx].amount
        items = []
        for so in [idx+1..sOpts.length-1]
             if sOpts[so].rec_level is '1' 
                 idx = so
                 break
             if sOpts[so].rec_type isnt "Группа"
                 groupAmount += sOpts[so].amount
                 items.push({name: sOpts[so].name, amount: sOpts[so].amount})
        groups.push({name: name, amount: groupAmount, items: items})
    console.log groups
    groups
        
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
                                className: "fi-plus"
                            React.DOM.span null,
                                " #{@props.options[idx].name}"
                        React.DOM.div
                            "data-so-group": idx
                            style: {display: "none"}
                            React.DOM.table key: "table-#{@props.options[idx].id}",
                                React.DOM.tbody null,
                                    for so in [idx+1..@props.options.length-1]
                                         if @props.options[so].rec_level is '1' 
                                             idx = so
                                             break
                                         if @props.options[so].rec_type isnt "Группа"
                                             React.DOM.tr key: "#{so}-ot",
                                                 React.DOM.td null, @props.options[so].name
                                                 React.DOM.td 
                                                     className: "text-right", 
                                                     SelOptAmount(@props.options[so].amount) 
                    
@BFSSelectedOptionsDarkBlue = React.createClass
    componentDidMount: ->
        $("[data-so-group-id]").click ()->
            if $(this).find("i").hasClass("fi-plus")
                $(this).find("i").attr("class", "fi-minus")
                $("[data-so-group=#{$(this).attr("data-so-group-id")}]").slideDown(300)
            else
                $("[data-so-group=#{$(this).attr("data-so-group-id")}]").slideUp(300)
                $(this).find("i").attr("class", "fi-plus")
    render: -> 
        grps = GroupSelectedOptions(@props.options)
        idx = 0
        React.DOM.div
            className: "row",
            React.DOM.div
                className: "small-12 columns"
                React.DOM.div
                    style: {paddingTop: "0.25rem", paddingBottom: "0.25rem"}
                    className: "blue-bg",
                    for g in grps
                        idx++
                        React.DOM.div
                            key: "option-group-#{idx}"
                            React.DOM.div
                                className: "row"
                                React.DOM.div
                                    className: "small-8 columns"
                                    React.DOM.h5 
                                        style: {marginLeft: "1.25rem", cursor: "pointer"}
                                        "data-so-group-id": idx
                                        React.DOM.i
                                            className: "fi-plus"
                                        React.DOM.span null,
                                            " #{g.name}"
                                React.DOM.div
                                    className: "small-4 columns"
                                    React.DOM.p null, if g.amount is 0 then "Входит в стд. комплектацию" else SelOptAmount(g.amount)
                            React.DOM.div
                                "data-so-group": idx
                                style: {display: "none"}
                                React.DOM.table key: "table-#{idx}",
                                    React.DOM.tbody null,
                                        for so in g.items
                                            idx++
                                            React.DOM.tr key: "#{idx}-ot",
                                                 React.DOM.td null, 
                                                     React.DOM.div 
                                                         className: "row"
                                                         React.DOM.div 
                                                             className: "small-8 columns"
                                                             so.name
                                                         React.DOM.div
                                                             className: "small-4 columns"
                                                             if so.amount is 0
                                                                 React.DOM.i
                                                                      className: "fi-check"
                                                                      title: "Входит в стандартную комплектацию"
                                                                      ""
                                                             else SelOptAmount(so.amount) 

@BoatForSaleShow = React.createClass
    render: -> 
        React.DOM.div null,
            React.DOM.div
                className: "dark-blue-bg tb-pad-s"
                React.DOM.div
                    className: "row "
                    React.DOM.div
                        className: "small-6 columns text-center"
                        React.DOM.p null, "Стоимость опций" 
                    React.DOM.div
                        className: "small-6 columns text-center"
                        React.DOM.p null, "Общая стоимость лодки"
                        React.DOM.p className: "stat", SelOptAmount(@props.bfs.amount)
            React.createElement BFSSelectedOptionsDarkBlue, options: @props.bfs.selected_options
    #toggleGroup: (g)->
    #    @props.updBfsListFunc(@props.groups.map (grp)-> if grp.name is g.name then g else grp)
    #render: ->
    #    React.DOM.div
    #        id: 'bfs-show'
    #        for g in @props.groups
    #            if g.isEnable then React.createElement BoatForSaleGroup, key: "group-#{g.id}", group: g, bfsList: @props.bfs.selected_options_for_show, toggleHandle: @toggleGroup 
        

MiniBlockParameterRow = React.createClass
    render: ->
        React.DOM.div
            className: "row"
            React.DOM.div
                className: "small-6 columns text-center"
                React.DOM.p null, @props.p.name
            React.DOM.div
                className: "small-6 columns text-center"
                React.DOM.p null, @props.p.value
                    
@BFSWideBlock = React.createClass
    componentDidMount: ->
        $("[data-bfs-id=#{@props.bfs.id}]").fadeIn(500)
    componentWillUnmount: ->
        $("[data-bfs-id=#{@props.bfs.id}]").fadeOut(500)
    moreClickHandle: (e)->
        if @props.goToBfsClickHandle isnt undefined
            e.preventDefault()
            @props.goToBfsClickHandle(@props.bfs.id)
    render: ->
        i = 0
        React.DOM.div 
            className: "row"
            React.DOM.div
                className: "small-12 columns"
                React.DOM.div
                    className: "light-gray-bg"
                    React.DOM.div
                        className: "row bfs-wide-block"
                        "data-bfs-id": @props.bfs.id
                        style: {display: "none"}
                        React.DOM.div
                            className: "small-6 medium-5 columns"
                            React.DOM.img
                                src: @props.bfs.photo.medium
                        React.DOM.div
                            className: "small-6 medium-7 columns"
                            React.DOM.h5 null, @props.bfs.name
                            React.DOM.div
                                className: "parameters"
                                for p in @props.bfs.parameters
                                    React.createElement MiniBlockParameterRow, key: "parameter-#{i++}", p: p
                            React.DOM.a
                                className: "button small expanded"
                                href: "/boat_for_sales/#{@props.bfs.id}"
                                onClick: @moreClickHandle 
                                "ПОДРОБНЕЕ"
                    
@BFSMiniBlock = React.createClass
    componentDidMount: ->
        $("[data-bfs-id=#{@props.bfs.id}]").fadeIn(500)
    componentWillUnmount: ->
        $("[data-bfs-id=#{@props.bfs.id}]").fadeOut(500)
    moreClickHandle: (e)->
        if @props.goToBfsClickHandle isnt undefined
            e.preventDefault()
            @props.goToBfsClickHandle(@props.bfs.id)
    render: ->
        i = 0
        React.DOM.div
            className: "column"
            React.DOM.div
                className: "bb-mini-block"
                "data-bfs-id": @props.bfs.id
                style: {display: "none"}
                React.DOM.div 
                    className: "text-center dark-blue-bg"
                    React.DOM.h6 null, @props.bfs.name
                React.DOM.div
                    className: "row"
                    React.DOM.div
                        className: "small-12 columns text-center"
                        React.DOM.p null, 
                            React.DOM.span className: "amount", "#{AddWhiteSpaceToNumb(@props.bfs.amount)}"
                            React.DOM.span className: "rubl", " "
                React.DOM.div
                    className: "row"
                    React.DOM.div
                        className: "small-12 columns text-center"
                        React.DOM.p null, @props.bfs.region
                React.DOM.img
                    src: @props.bfs.photo.wide_small 
                React.DOM.div
                    className: "parameters"
                    for p in @props.bfs.parameters
                        React.createElement MiniBlockParameterRow, key: "parameter-#{i++}", p: p
            React.DOM.a
                className: "button tiny expanded"
                href: "/boat_for_sales/#{@props.bfs.id}"
                onClick: @moreClickHandle 
                "ПОДРОБНЕЕ"
                
                                            


@BoatForSalePhotos = React.createClass
    render: ->
        React.DOM.div null,
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.div
                        className: "dark-blue-bg"
                        React.DOM.div
                            className: "row"
                            React.DOM.div
                                className: "small-6 columns tb-pad-xs"
                                React.DOM.img
                                    style: {paddingLeft: "25px", height: "40px"}
                                    src: @props.b.trademark.white_logo.small
                            React.DOM.div
                                className: "small-6 columns tb-pad-xs text-right"
                                React.DOM.h6 
                                    style: {padding: "10px 25px 0 0"}
                                    @props.b.name
            React.DOM.img
                "data-interchange": MakeInterchangeData(@props.b.photo, true)
                style: {width: "100%"}
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.div
                        className: "light-gray-bg"
                        React.DOM.div
                            className: "row tb-pad-xs small-up-2 medium-up-3"
                            for i in [0..@props.prms.length-1]
                                if i > 5 then break
                                React.DOM.div
                                    key: "parameter-#{i}"
                                    className: "column tb-pad-xs"
                                    React.DOM.p 
                                         className: "rc-param-name-b text-center"
                                         @props.prms[i].name
                                    React.DOM.div
                                         className: "stat text-center rc-param-val-b"
                                         React.DOM.span null, @props.prms[i].value
                                    


@BoatForSaleInFilter = React.createClass
    getInitialState: ->
       type: @props.data
       parameters: @props.data.parameters
       photos: @props.data.photos
       bfsList: @props.data.boat_for_sales
       curBfs: if @props.data.bfs is undefined then null else @props.data.bfs
    getDefaultProps: ->
       type: null
       parameters: []
       photos: []
       bfsList: []
    componentDidMount: ->
        InitViewer()
        $("#boat_type_block").foundation()
        $("#boat_type_block").fadeIn(500)
        initTabs() #инициализация таб
        #console.log "componentDidMount()"
    componentWillUnmount: ->
        #console.log "componentWillUnmount()"
    getCurrentModificationId: ->
        #поиск модификации по выбранному стандарту лодки
        if @state.type.modifications.length is 0 then return null
        if @state.curBfs is null then return -1
        id = -1
        for so in @state.curBfs.selected_options
            if so.rec_type is "Стандарт"
                for i in [0..@state.type.modifications.length-1]
                    if @state.type.modifications[i].boat_option_type_id is so.boat_option_type_id
                        id = i
                        break
                    if id isnt -1 then break
        return id
                 
    render: ->
        curMdf = @getCurrentModificationId()
        React.DOM.div 
            id: "boat_type_block"
            style: {display: "none"},
            React.createElement BoatForSalePhotos, b: @state.type, prms: @state.parameters
            React.createElement BoatForSaleShow, key: "bfs-#{@state.curBfs.id}", bfs: @state.curBfs
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
                        React.DOM.li
                            className: "tabs-title is-active"
                            React.DOM.a
                                href: "#description"
                                "Описание"
                        React.DOM.li
                            className: "tabs-title"
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
                    className: "tabs-panel#{if @state.curBfs isnt null then "" else " is-active"}"
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
                if @state.curBfs isnt null
                    React.DOM.div
                        className: "tabs-panel is-active"
                        id: "description"
                        "data-animate":"fade-in fade-out"
                        if curMdf isnt null and curMdf isnt -1
                            React.createElement BoatModificationRow, key: "mdf-#{@state.type.modifications[curMdf].id}", mdf: @state.type.modifications[curMdf]
                        React.DOM.h4 null, "Комлектность"
                        #React.createElement BFSSelectedOptions, options: @state.curBfs.selected_options
                        #React.createElement BFSFilteringResult, key: "bfs-list", data: @state.bfsList, colsClass: "small-up-1 medium-up-2 large-up-3"
                        #React.createElement BoatForSales, key: "bfs-list", bfsList: @state.bfsList, curBfs: @state.bfsList    
