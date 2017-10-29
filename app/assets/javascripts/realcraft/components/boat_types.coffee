@RCHeader = React.createClass
    render: ->
        React.DOM.div
            id: 'rc-header'
            if @props.h3 isnt undefined
                React.DOM.h3 null, @props.h3.toUpperCase()
            if @props.h1 isnt undefined
                React.DOM.h1 null, @props.h1.toUpperCase()
            if @props.h4 isnt undefined
                React.DOM.h4 null, @props.h4.toUpperCase()

@BoatTypeShow = React.createClass
    getInitialState: ->
        boat_type: @props.boat_type
    smlVersDescr: ->
        React.DOM.div 
            className: 'c-box hide-for-large dark-blue-bg'
            React.DOM.div 
                className: 'row tb-pad-s'
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.p null, @state.boat_type.description
    componentDidMount: ->
        #$('#boat_type_template').foundation()
    render: ->
        React.DOM.div
            id: 'boat_type_template',
            if not IsEmptyString(@state.boat_type.description) then @smlVersDescr()
            React.createElement OnPatternParametersList, boat_type: @state.boat_type
            React.createElement BoatTypePageInfoTabs, boat_type: @state.boat_type

BoolVal = (vals)-> 
    if vals.length > 1 
        "Да"
    else 
        if vals[0] then "Да" else "Нет"
RangeVal = (vals)->
    min = max = vals[0]
    if vals.length is 1 then return "#{min}"
    for v in vals 
        if v > max then max = v
        if v < min then min = v
    return "#{min}-max"
       


MakeModificationsParamsList = (bType)-> 
    props = []
    for i in [0..bType.modifications[0].properties.length-1]
        p = bType.modifications[0].properties[i]
        vals = []
        prop = {type: p.type, value: null, short_name: p.short_name, name: p.name, measure: if p.measure is '' then '' else " #{p.measure}"}
        for mdf in bType.modifications
            mp = mdf.properties[i]
            if mp.is_binded && $.trim(mp.name).length>0 then PushIfIsUniq(vals, mp.value)
        if vals.length is 0 then continue
        else
            if p.type is 'bool' then prop.value = BoolVal(vals)
            else if p.type is 'integer' or p.type is 'float' then prop.value =  RangeVal(vals)
            else  prop.value = vals.join()
            props.push(prop)
    return props
        
                 
@OnPatternParametersList = React.createClass
    getInitialState: ->
        bigPrmsNumber: 3
        smallPrmsNumber: 6
        mdfsProperties: MakeModificationsParamsList(@props.boat_type)
    render: ->
        React.DOM.div
            className: 'white-text'
            id: 'rc-parameters'
            React.DOM.div
                className: 'tb-pad-s'
                React.DOM.div
                    className: 'row'
                    React.DOM.div
                        className: 'small-12 columns'
                        React.DOM.h3
                            className: 'text-center'
                            Dict.technical_information.toUpperCase()
            React.DOM.div 
                className: "small-up-3 row"
                for i in [0..@state.bigPrmsNumber-1]
                    React.createElement ParameterCell, key: "prm-cell-#{i}", p: @state.mdfsProperties[i], type: 'b'
            React.DOM.div 
                className: "small-up-2 medium-up-4 large-up-6 row"
                for i in [@state.bigPrmsNumber..@state.smallPrmsNumber+@state.bigPrmsNumber-1]
                    React.createElement ParameterCell, key: "prm-cell-#{i}", p: @state.mdfsProperties[i], type: 's'

@ParameterCell = React.createClass
    getInitialState: ->
        rowClass: if @props.type is "s" then 'small-up-2 medium-up-4 large-up-6' else "small-up-4"
    render: ->
        React.DOM.div
            className: "column tb-pad-s"
            React.DOM.p
                className: "rc-param-name-#{@props.type} text-center"
                @props.p.short_name
            React.DOM.div 
                className: "stat text-center rc-param-val-#{@props.type}"
                "#{@props.p.value}#{@props.p.measure}"


TabsLinkItem = React.createClass
    handleClick: (e)->
        e.preventDefault()
        @props.selectHandle(@props.tab.name)
    isActClass: ->
        if @props.tab.isActive then ' is-active' else ''
    render: ->
        React.DOM.li
            className: 'tabs-title small-6 medium-3 columns text-center' + @isActClass()
            React.DOM.a
                className: 'no-style'
                href: "##{@props.tab.name}"
                onClick: @handleClick
                'aria-selected': @props.tab.isActive
                Dict[@props.tab.name].toUpperCase()

TabsPageItem = React.createClass
    render: ->
        React.DOM.div
            id: 'tab-page'
            React.DOM.div
                className: 'row'
                React.DOM.div 
                    className: 'small-12 columns tb-pad-s'
                    React.createElement RCHeader, h3: @props.boat_type.name, h1: Dict[@props.tab.name]
            if @props.tab.name is 'modifications' then React.createElement BoatTypeModificationsPart, boat_type: @props.boat_type
    
                
                
@BoatTypePageInfoTabs = React.createClass 
    getInitialState: ->
        tabs: [
                {name: "modifications", isActive: true}, 
                {name: "engeneering", isActive: false}, 
                {name: "photos", isActive: false}, 
                {name: "videos", isActive: false}
               ]
    curTab: ->
        console.log @state.tabs
        for tab in @state.tabs
            if tab.isActive then return tab
        return @state.tabs[0]
    changeTabsHandle: ->
        tab = @curTab()
        tabHash = "#"+tab.name
        hash = GetReqHash()
        loc = window.location
        if hash.length > 0
            loc = loc.replace(hash, tabHash)
        else
            loc += tabHash
        tOffset = $("#rc-data-tabs").offset().top - 20
        curScroll = $(window).scrollTop()
        history.pushState('', '', tabHash)
        if Math.abs(tOffset-curScroll) > 15 then $('html, body').stop(true, true).animate({ scrollTop: tOffset }, 1000)
        return false
    componentDidMount: ->
        hash = GetReqHash()
        if hash.length > 1 then @selectTab(hash.replace("#", ''))
        window.onhashchange = ()=>
            hash = GetReqHash()
            if hash.length > 1 then @selectTab(hash.replace("#", ''))
    selectTab: (tabName)->
        tabs = @state.tabs.slice()
        hasActive = false
        tabs = tabs.map (tab)->
            flag = tab.name is tabName
            if not hasActive then hasActive = flag
            tab.isActive = flag
            tab
        if not hasActive then tabs[0].isActive = true
        console.log tabs
        @setState tabs: tabs 
        @changeTabsHandle()
    render: ->
        React.DOM.div
            id: "bt_tabs"
            React.DOM.ul
                id: 'rc-data-tabs'
                className: 'tabs'
                'data-turbolinks': false
                React.DOM.div
                    className: 'row'
                    for tab in @state.tabs
                        React.createElement TabsLinkItem, key: "taburl-#{tab.name}", tab: tab, selectHandle: @selectTab
            React.DOM.div
                className: 'tab-content'
                React.createElement TabsPageItem, tab: @curTab(), boat_type: @props.boat_type

@BoatTypeModificationsPart = React.createClass
    getInitialState: ->
        couldBeTxt: if IsRuLocale() then "Лодки #{@props.boat_type.name} поставляются в #{@props.boat_type.modifications.length} модификациях" else "#{@props.boat_type.name} boats can be delivered in #{@props.boat_type.modifications.length} versions of equipment packages" 
    render: ->
        React.DOM.div null,
            if @props.boat_type.modifications.length > 0
                React.DOM.div 
                    className: 'row'
                    React.DOM.div
                        className: 'small-12 columns'
                        @state.couldBeTxt
                for m in @props.boat_type.modifications
                    React.createElement ModificationInfo, key: "mdf-#{m.id}", bt: @props.boat_type, m: m
                    
@ModificationInfo = React.createClass
     accmdText: ->
         crewLimit = GetPropertyValueTag(@props.m.properties, 'crew_limit')
         if IsRuLocale
             "В модификации #{@props.m.name} #{crewLimit} человек могут быть размещены согласно следующим схемам."
         else  
             "#{crewLimit} people #{@props.m.name} can be accommodated according to the following schemes."
     componentDidMount: ->
         InitViewer()
     render: ->
         React.DOM.div null,              
             React.DOM.hr null, null
             React.DOM.div
                 className: 'rc-modification-box tb-pad-s'
                 React.DOM.div
                     className: 'row'
                     React.DOM.div
                         className: 'small-12 medium-6 columns'
                         React.DOM.h3 null, @props.m.name
                         React.DOM.p null, @props.m.description
                     React.DOM.div
                         className: 'small-12 medium-4 medium-offset-2 large-2 large-offset-4 columns text-right'
                         React.DOM.a
                             className: 'button expanded rc-primary-blue'
                             'data-open-boat-form': "#{@props.bt.name} #{@props.m.name}"
                             Dict.buy.toUpperCase()
                 if @props.m.model_views.length > 0
                     React.DOM.div
                         className: 'small-up-12 medium-up-2 large-up-3 row'
                         for v in @props.m.model_views
                             React.createElement ModelViewItem, key: v.title, v: v, title: "#{@props.bt.name} #{@props.m.name}", collection_name: "boat-views-#{@props.m.id}"
                 if @props.m.accomodation_views.length > 0
                     React.DOM.div null,
                         React.DOM.div
                             className: 'row'
                             React.DOM.div
                                 className: 'small-12 columns'
                                 React.DOM.h3 null, "#{Dict.crew_accomodation.toUpperCase()}"
                         React.DOM.div 
                             className: 'row tb-pad-s'
                             React.DOM.div 
                                 className: 'medium-12 large-2 columns'
                                 React.DOM.p null, @accmdText()
                             React.DOM.div
                                 className: 'medium-12 large-10 columns'
                                 React.DOM.div
                                      className: "small-up-2 medium-up-#{if @props.m.accomodation_views.length > 2 then 3 else 2 } row"
                                      for i in [0..@props.m.accomodation_views.length-1]
                                          React.createElement AccViewItem, key: "acc-view-#{i}", v: @props.m.accomodation_views[i], idx: i+1
 
@ModelViewItem = React.createClass
    render: ->
        React.DOM.div
            className: 'column tb-pad-s'
            React.DOM.div
                style: {position: 'relative'}
                React.DOM.div
                    style: {position: 'absolute', top: '10px', right: '10px', zIndex: '200'}
                    React.DOM.p null, Dict[@props.v.title]
            React.DOM.a null,
                React.DOM.img
                    className: 'kra-ph-box'
                    'data-collection': @props.collection_name
                    'data-rc-box-title': "#{@props.title}: #{Dict[@props.v.title]}"
                    'data-image-versions': "[#{@props.v.small}, small], [#{@props.v.medium}, medium], [#{@props.v.large}, large]}"
                    src: @props.v.small

@AccViewItem = React.createClass
    render: ->
        React.DOM.div
            className: 'columns'
            React.DOM.p null, "#{Dict.scheme} #{@props.idx}"
            React.DOM.img
                src: @props.v.small

                
