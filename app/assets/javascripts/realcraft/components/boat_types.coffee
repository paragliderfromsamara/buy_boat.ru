#@BoatParameterType = React.createClass
#    render: ->


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

@BoatTypeTitleBlock = React.createClass
    render: ->
        React.DOM.div null,#className: "tb-pad-s"
            React.DOM.div 
                className: "bb-wide-block"
                "data-interchange": MakeInterchangeData(@props.b.photo, true)
                React.DOM.div
                    className: "rc-fog hard-fog dark-blue-bg"
                    null
                React.DOM.div
                    className: "row tb-pad-s"
                    React.DOM.div
                        className: "small-12 columns text-center"
                        React.DOM.h3 null, @props.b.name
                React.DOM.div
                    className: "row show-for-large"
                    React.DOM.div
                        className: 'medium-12 columns text-center'
                        React.DOM.p
                            title: @props.b.description,
                            TrimText(@props.b.description, 500)
                React.DOM.div
                    className: "row tb-pad-s"
                    for i in [0..@props.prms.length-1]
                        if i > 5 then break
                        React.DOM.div
                            key: "parameter-#{i}"
                            className: "small-2 columns"
                            React.DOM.div
                                 className: "stat text-center rc-param-val-b"
                                 React.DOM.span null, @props.prms[i].value
                            React.DOM.p 
                                 className: "rc-param-name-b text-center"
                                 @props.prms[i].name
                React.DOM.div
                    className: "row"
                    React.DOM.div
                        className: "small-12 columns"
                        React.DOM.img
                            className: "float-center"
                            src: @props.b.trademark.white_logo.small
                    #        className: "button expanded"
                    #        href: "#"
                    #        "ПОДРОБНЕЕ"
                    #React.DOM.div
                    #    className: "small-4 small-offset-4 columns"
                    #    React.DOM.a
                    #        className: "button expanded"
                    #        href: "#"
                    #        "КУПИТЬ"

@BoatModificationRow = React.createClass
    modelViews: ->
        views = []
        if @props.mdf.views.aft isnt null then views.push({title: "Вид спереди", view: @props.mdf.views.aft})
        if @props.mdf.views.bow isnt null then views.push({title: "Вид сзади", view: @props.mdf.views.bow})
        if @props.mdf.views.top isnt null then views.push({title: "Вид сверху", view: @props.mdf.views.top})
        return views
    render: ->
        views = @modelViews()
        React.DOM.div null,
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.h4 null, @props.mdf.name
            if views.length > 0
                React.DOM.div
                    className: "row tb-pad-s small-up-2 medium-up-3",
                    for v in views
                        React.DOM.div
                            key: "view-#{v.title}"
                            className: "column"
                            React.DOM.h6 null, v.title
                            React.DOM.img
                                "data-interchange": MakeInterchangeData(v.view)
                
@BoatTypeShow = React.createClass
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
            id: "boat_type_block",
            style: {display: "none"}
            React.createElement BoatTypeTitleBlock, b: @state.type, prms: @state.parameters
            if @state.curBfs isnt null then React.createElement BoatForSaleShow, key: "bfs-#{@state.curBfs.id}", bfs: @state.curBfs
            if curMdf isnt null and curMdf isnt -1
                React.createElement BoatModificationRow, key: "mdf-#{@state.type.modifications[curMdf].id}", mdf: @state.type.modifications[curMdf]
            else
                React.DOM.div null,
                    for mdf in @state.type.modifications
                        React.createElement BoatModificationRow, key: "mdf-#{mdf.id}", mdf: mdf
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
                        if @state.curBfs isnt null
                            React.DOM.li
                                className: "tabs-title is-active"
                                React.DOM.a
                                    href: "#options-collection"
                                    "Комплектация"
                        React.DOM.li
                            className: "tabs-title#{if @state.curBfs isnt null then "" else " is-active"}"
                            React.DOM.a
                                href: "#technical"
                                "Технические характеристики"
                        React.DOM.li
                            className: "tabs-title"
                            React.DOM.a
                                href: "#photos"
                                "Фото"
                        if @state.bfsList.length > 0
                            React.DOM.li
                                className: "tabs-title"
                                React.DOM.a
                                    href: "#available-collection"
                                    "В наличии"
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
                if @state.bfsList.length > 0
                    React.DOM.div
                        className: "tabs-panel"
                        id: "available-collection"
                        "data-animate":"fade-in fade-out"
                        React.DOM.div
                            className: "row"
                            React.DOM.div
                                className: "small-12"
                                React.DOM.h3
                                     className: "tb-pad-s"
                                     "Доступные комплектации #{@state.type.name}"
                        React.createElement BFSFilteringResult, key: "bfs-list", data: @state.bfsList, colsClass: "small-up-1 medium-up-2 large-up-3"
                        #React.createElement BoatForSales, key: "bfs-list", bfsList: @state.bfsList, curBfs: @state.bfsList
                if @state.curBfs isnt null
                    React.DOM.div
                        className: "tabs-panel is-active"
                        id: "options-collection"
                        "data-animate":"fade-in fade-out"
                        React.createElement BFSSelectedOptions, options: @state.curBfs.selected_options
                        #React.createElement BFSFilteringResult, key: "bfs-list", data: @state.bfsList, colsClass: "small-up-1 medium-up-2 large-up-3"
                        #React.createElement BoatForSales, key: "bfs-list", bfsList: @state.bfsList, curBfs: @state.bfsList
