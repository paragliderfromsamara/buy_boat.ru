#@BoatParameterType = React.createClass
#    render: ->

#Используется для отображения цены в таблице с выбранными опциями

getCurBfsById = (bfss, id)->
    if bfss.length is 0 then return null
    if id is undefined or id is null then id = bfss[0].id
    for bfs in bfss
        if id is bfs.id then return bfs     
    return null


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
    groups
        

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
        React.DOM.div null,
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
                                React.createElement IconWithText, fig: "plus", txt: "#{g.name}"    
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
    getInitialState: ->
        products_amount: 0
        selected_products: []
    sumAmount: ->
        @props.b.bfs.amount + @state.products_amount
    updProductsAmount: (a)->
        @setState products_amount: a
    render: -> 
        React.DOM.div null,
            React.DOM.div
                className: "dark-blue-bg tb-pad-s"
                React.DOM.div
                    className: "row "
                    React.DOM.div
                        className: "small-12 medium-4 columns text-center"
                        React.DOM.p null, "Общая стоимость лодки"
                        React.DOM.p className: "stat", id: "sum-amount", SelOptAmount(@sumAmount())
                        React.DOM.a
                            className: "button success expanded"
                            href: ""
                            React.createElement IconWithText, fig: "shopping-cart", txt: "КУПИТЬ"
            React.DOM.div
                className: "row",
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.div
                        style: {paddingTop: "0.25rem", paddingBottom: "0.25rem"}
                        className: "blue-bg",
                        React.createElement ShopProductsMenu, b: @props.b, updAmount: @updProductsAmount
                        React.createElement BFSSelectedOptionsDarkBlue, options: @props.b.bfs.selected_options, products: @state.selected_products
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
                
WideBlockParameterRow = React.createClass
    render: ->
        React.DOM.div
            className: "column text-center"
            React.DOM.p null, @props.p.name
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
            className: "bb-list-block",
            React.DOM.div 
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.div
                        className: "head-row"
                        React.DOM.div
                            className: "row"
                            React.DOM.div
                                className: "small-6 columns"
                                React.DOM.h6 null, @props.bfs.name
                            React.DOM.div
                                className: "small-6 columns text-right"
                                React.DOM.h6 null, "#{SelOptAmount(@props.bfs.amount)}"
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
                                className: "small-12 large-5 columns"
                                React.DOM.img
                                    src: @props.bfs.photo.medium
                                    "data-interchange": "[#{@props.bfs.photo.wide_small}, small], [#{@props.bfs.photo.wide_medium}, medium], [#{@props.bfs.photo.medium}, large]"
                            React.DOM.div
                                className: "small-12 large-7 columns"
                                React.DOM.div
                                    className: "text-center"
                                    React.DOM.p 
                                        className: "tb-pad-xs", 
                                        "#{@props.bfs.region}, #{@props.bfs.city}"
                                React.DOM.div
                                    className: "parameters row small-up-3"
                                    for p in @props.bfs.parameters
                                        React.createElement WideBlockParameterRow, key: "parameter-#{i++}", p: p
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
                        React.createElement MiniBlockParameterRow, key: "parameter-#{p.name}", p: p
            React.DOM.a
                className: "button tiny expanded"
                href: "/boat_for_sales/#{@props.bfs.id}"
                onClick: @moreClickHandle 
                "ПОДРОБНЕЕ"
                
                                            


@BoatForSalePhotos = React.createClass
    componentDidMount: ->
        $("[data-show-params]").click ->
            dispIsNone = $("[data-params-table]").css('display') is "none"
            if dispIsNone then $("[data-params-table]").slideDown(300) else $("[data-params-table]").slideUp(300)
            $(this).text(if !dispIsNone then "ПОКАЗАТЬ ВСЕ ХАРАКТЕРИСТИКИ" else "СКРЫТЬ ТАБЛИЦУ")
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
            React.createElement PhotoSimpleSlider, phs: @props.b.photos
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 medium-6 columns tb-pad-s"
                    React.DOM.h6 null, "Место нахождения"
                    React.DOM.a 
                        href: "/shops/#{@props.b.bfs.shop.id}",
                        target: "_blank" 
                        "#{@props.b.bfs.shop.name}, #{@props.b.bfs.shop.location}"
                React.DOM.div
                    className: "small-12 medium-6 columns tb-pad-s"
                    React.DOM.h6 null, "О лодке"
                    @props.b.description
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.div
                        className: "light-gray-bg"
                        React.DOM.div
                            className: "row tb-pad-xs small-up-2 medium-up-3"
                            for i in [0..@props.b.parameters.length-1]
                                if i > 5 then break
                                React.DOM.div
                                    key: "parameter-#{i}"
                                    className: "column tb-pad-xs"
                                    React.DOM.p 
                                         className: "rc-param-name-b text-center"
                                         @props.b.parameters[i].name
                                    React.DOM.div
                                         className: "stat text-center rc-param-val-b"
                                         React.DOM.span null, @props.b.parameters[i].value
                        React.DOM.div 
                            className: "row"
                            React.DOM.div
                                className: "small-12 columns"
                                React.DOM.a
                                    "data-show-params": ""
                                    className: "button expanded"
                                    "ПОКАЗАТЬ ВСЕ ПАРАМЕТРЫ"
                        React.DOM.div
                            className: 'row'
                            "data-params-table": ""
                            style: {display: "none"}
                            React.DOM.div
                                className: "small-12 columns"
                                React.createElement BoatParameterValuesTableShow, key: "BoatParameterValuesTableShow", data: @props.b.parameters
                                    


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
        $("#boat_type_block").fadeIn(500)
        $("#boat_type_block").foundation()
       # initTabs() #инициализация таб
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
            React.createElement BoatForSalePhotos, b: @state.type
            React.createElement BoatForSaleShow, key: "bfs-#{@state.curBfs.id}", b: @state.type 


BFSManageTableRow = React.createClass
    editRowHandle: (e)->
        e.preventDefault()
        @props.editRowToggleHandle(@props.bfs.id)
    render: ->
        if @props.isEdit
            React.DOM.tr null,
                React.DOM.td null, @props.bfs.name
                React.DOM.td null, @props.bfs.amount
                React.DOM.td null, @props.bfs.discount
                React.DOM.td null, @props.bfs.request_limit
                React.DOM.td null, 
                    React.DOM.a
                        onClick: @editRowHandle
                        React.createElement IconWithText, txt: "сохранить", fig: 'save'
        else
            React.DOM.tr null,
                React.DOM.td null, @props.bfs.name
                React.DOM.td null, @props.bfs.amount
                React.DOM.td null, @props.bfs.discount
                React.DOM.td null, @props.bfs.request_limit
                React.DOM.td null, 
                    React.DOM.a
                        onClick: @editRowHandle
                        React.createElement IconWithText, txt: "изменить", fig: 'pencil'
                    
@BFSManageTable = React.createClass
    getInitialState: ->
        bfss: @props.data
        edRowId: null
    getDefaultProps: ->
        bfss: []
        edRowId: null
    editRowToggle: (id)->
        @setState edRowId: id
    render: ->
        React.DOM.div
            className: "row"
            React.DOM.div 
                className: "small-12 columns"
                React.DOM.table null,
                    React.DOM.thead null,
                        React.DOM.tr null,
                            React.DOM.th null, "Название лодки"
                            React.DOM.th null, "Стоимость"
                            React.DOM.th null, "Скидка, %"
                            React.DOM.th null, "Количество, шт."
                            React.DOM.th null, null
                    React.DOM.tbody null,
                        for bfs in @state.bfss
                            React.createElement BFSManageTableRow, key: "bfs-#{bfs.id}", bfs: bfs, isEdit: (@state.edRowId is bfs.id), editRowToggleHandle: @editRowToggle

                            
        