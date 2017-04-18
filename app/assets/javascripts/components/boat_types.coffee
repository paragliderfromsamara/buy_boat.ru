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
        React.DOM.div
            className: "tb-pad-s"
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
        #console.log "componentDidMount()"
    componentWillUnmount: ->
        #console.log "componentWillUnmount()"
    render: ->
        React.DOM.div null,
            React.createElement BoatTypeTitleBlock, b: @state.type, prms: @state.parameters
            if @state.curBfs isnt null then React.createElement BoatForSaleShow, key: "bfs-#{@state.curBfs.id}", bfs: @state.curBfs
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
                            className: "tabs-title#{if @state.bfsList.length > 0 then "" else " is-active"}"
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
